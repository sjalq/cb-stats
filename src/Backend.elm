module Backend exposing (..)

import Api.Data
import Api.Logging as Logging exposing (..)
import Api.User
import Bridge exposing (..)
import Crypto.Hash
import Dict
import Dict.Extra as Dict
import Env
import Gen.Msg
import Http
import Json.Encode
import Lamdera exposing (..)
import Pages.Example
import Pages.Login
import Pages.Register
import Random
import Random.Char
import Random.String
import Shared exposing (Msg(..))
import String exposing (fromInt)
import Task
import Time
import Time.Extra as Time
import Types exposing (BackendModel, BackendMsg(..), FrontendMsg(..), ToFrontend(..), hasExpired)


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \_ -> onConnect OnConnect
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { users = Dict.empty
      , authenticatedSessions = Dict.empty
      , incrementedInt = 0
      , logs = []
      , clientCredentials = []
      }
    , Cmd.none
    )


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        OnConnect sessionId clientId ->
            ( model, Time.now |> Task.perform (VerifySession sessionId clientId) )

        AuthenticateSession sessionId clientId user now ->
            ( { model
                | authenticatedSessions =
                    model.authenticatedSessions
                        |> Dict.insert sessionId
                            { user = user.email
                            , expires = now |> Time.add Time.Hour 24 Time.utc
                            }
              }
            , sendToShared clientId <| SignInUser <| user
            )

        VerifySession sessionId clientId now ->
            let
                maybeVerifiedUser =
                    model.authenticatedSessions
                        |> Dict.get sessionId
                        |> Maybe.andThen
                            (\session ->
                                if session |> hasExpired now then
                                    Nothing

                                else
                                    model.users |> Dict.get session.user
                            )
            in
            case maybeVerifiedUser of
                Nothing ->
                    ( model, sendToShared clientId <| SignOutUser )

                Just user ->
                    ( model, sendToShared clientId <| SignInUser <| Api.User.toUser user )

        RegisterUser sessionId clientId user salt ->
            let
                newUser =
                    { email = user.email
                    , role =
                        if Api.User.isAdminEmail user.email then
                            Api.User.Admin

                        else if Api.User.isEditorEmail user.email then
                            Api.User.Editor

                        else
                            Api.User.Basic
                    , passwordHash = hashPassword user.password salt
                    , salt = salt
                    }
            in
            ( { model | users = model.users |> Dict.insert user.email newUser }
            , Cmd.batch
                [ sendToPage clientId <|
                    Gen.Msg.Register <|
                        Pages.Register.GotUser <|
                            Api.Data.Success <|
                                Api.User.toUser newUser
                , Time.now |> Task.perform (AuthenticateSession sessionId clientId <| Api.User.toUser newUser)
                ]
            )

        NoOpBackendMsg ->
            ( model, Cmd.none )

        Log_ logMessage lvl posix ->
            ( model |> Logging.logToModel logMessage posix lvl, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        AttemptSignOut ->
            ( { model | authenticatedSessions = model.authenticatedSessions |> Dict.remove sessionId }
            , sendToShared clientId <| SignOutUser
            )

        AttemptSignIn user ->
            case model.users |> Dict.get user.email of
                Just existingUser ->
                    let
                        passwordHash =
                            hashPassword user.password existingUser.salt
                    in
                    if passwordHash == existingUser.passwordHash then
                        ( model
                        , Cmd.batch
                            [ sendToPage clientId <|
                                Gen.Msg.Login <|
                                    Pages.Login.GotUser <|
                                        Api.Data.Success <|
                                            Api.User.toUser existingUser
                            , performNow (AuthenticateSession sessionId clientId <| Api.User.toUser existingUser)
                            ]
                        )

                    else
                        ( model
                        , sendToPage clientId <|
                            Gen.Msg.Login <|
                                Pages.Login.GotUser <|
                                    Api.Data.Failure "Incorrect email or password."
                        )

                Nothing ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Login <|
                            Pages.Login.GotUser <|
                                Api.Data.Failure "Incorrect email or password."
                    )

        AttemptRegistration user ->
            let
                ( validEmail, validPass ) =
                    Api.User.validateUser user
            in
            case ( validEmail, validPass ) of
                ( True, True ) ->
                    case model.users |> Dict.get user.email of
                        Just _ ->
                            ( model
                            , sendToPage clientId <|
                                Gen.Msg.Register <|
                                    Pages.Register.GotUser <|
                                        Api.Data.Failure "This email address is already taken"
                            )

                        Nothing ->
                            ( model
                            , Random.generate (RegisterUser sessionId clientId user) randomSalt
                            )

                ( False, _ ) ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Register <|
                            Pages.Register.GotUser <|
                                Api.Data.Failure "Please enter a valid email address"
                    )

                ( _, False ) ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Register <|
                            Pages.Register.GotUser <|
                                Api.Data.Failure "Please enter a valid password"
                    )

        NoOpToBackend ->
            ( model, Cmd.none )

        AttemptGetCredentials ->
            ( model
            , sendToPage clientId <|
                Gen.Msg.Example <|
                    Pages.Example.GotCredentials <|
                        model.clientCredentials
            )



-- CRYPTO


randomSalt : Random.Generator String
randomSalt =
    Random.String.string 10 Random.Char.english


randomIdFromTime int time =
    (int |> fromInt) ++ "-" ++ (time |> Time.posixToMillis |> fromInt) |> Crypto.Hash.sha224 |> String.left 12


hashPassword password salt =
    Crypto.Hash.sha256 <| password ++ salt



-- HELPERS


isAdminSession : Model -> SessionId -> Bool
isAdminSession model sessionId =
    let
        maybeUser =
            model.authenticatedSessions
                |> Dict.get sessionId
                |> Maybe.map .user
                |> Maybe.andThen (\user -> model.users |> Dict.get user)
    in
    case maybeUser of
        Nothing ->
            False

        Just user ->
            user.role == Api.User.Admin


isAuthorised : Api.User.RequiredRole -> Model -> Time.Posix -> SessionId -> Bool
isAuthorised requiredRole model now sessionId =
    let
        maybeUserRole =
            model.authenticatedSessions
                |> Dict.get sessionId
                |> Maybe.andThen
                    (\session ->
                        if session |> not << hasExpired now then
                            model.users |> Dict.get session.user

                        else
                            Nothing
                    )
                |> Maybe.map (\user -> user.role)
    in
    case maybeUserRole of
        Just userRole ->
            userRole |> Api.User.checkAuthorization requiredRole

        Nothing ->
            False


sendToPage clientId page =
    sendToFrontend clientId <| PageMsg <| page


sendToShared clientId msg =
    sendToFrontend clientId <| SharedMsg <| msg


performNow task =
    Time.now |> Task.perform task
