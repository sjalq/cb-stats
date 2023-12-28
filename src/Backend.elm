module Backend exposing (..)

import Api.Data
import Api.Logging as Logging exposing (..)
import Api.PerformNow exposing (performNow)
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
import YouTubeApi


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { users = Dict.empty
      , authenticatedSessions = Dict.empty
      , incrementedInt = 0
      , logs = []
      , clientCredentials = Dict.empty
      }
    , Cmd.none
    )


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Time.every 10000 GetAccessTokens
        , onConnect OnConnect
        ]


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

        FetchChannels email ->
            ( model
            , Cmd.none
            )

        FetchAccessToken email ->
            -- if reftech the access token from the google api
            let
                maybeRefreshToken =
                    model.clientCredentials
                        |> Dict.get email
                        |> Maybe.map .refreshToken
            in
            ( model
            , -- case maybeRefreshToken of
              --     Just refreshToken ->
              --         YouTubeApi.refreshAccessToken Env.clientId Env.clientSecret refreshToken
              --         --|> Task.andThen (\newAccessToken -> Time.now |> Task.perform (GotFreshAccessTokenWithTime email newAccessToken))
              --         |> Task.perform (GotAccessTokenResponse email)
              --     Nothing ->
              Cmd.none
            )

        GotAccessTokenResponse email accessTokenResponse ->
            -- this gets called when the access token has been refreshed, but we don't yet have the system time
            ( model
              -- , performNow (GotFreshAccessTokenWithTime email accessTokenResponse)
            , Cmd.none
            )

        GotFreshAccessTokenWithTime email newAccessToken newTimestampPosix ->
            -- this gets called when the access token has been refreshed but we now have the system time also
            let
                newModel =
                    model.clientCredentials
                        |> Dict.get email
                        -- fetch the old credentials
                        |> Maybe.map (\old -> { old | accessToken = newAccessToken, timestamp = newTimestampPosix |> Time.posixToMillis })
                        -- update the access token
                        |> Maybe.map
                            (\new ->
                                { model | clientCredentials = model.clientCredentials |> Dict.insert email new }
                             -- insert the new credentials into the model
                            )
                        |> Maybe.withDefault model

                -- if there were no old credentials, just return the old model
            in
            ( newModel
            , Cmd.none
            )

        GotAccessToken email time accessTokenResponse ->
            case accessTokenResponse of
                Result.Ok accessToken ->
                    let
                        newModel =
                            model.clientCredentials
                                |> Dict.get email
                                -- fetch the old credentials
                                |> Maybe.map (\old -> { old | accessToken = accessToken.accessToken, timestamp = time |> Time.posixToMillis })
                                -- update the access token
                                |> Maybe.map (\new -> { model | clientCredentials = model.clientCredentials |> Dict.insert email new })
                                |> Maybe.withDefault model

                        -- if there were no old credentials, just return the old model
                    in
                    ( newModel
                    , Cmd.none
                    )

                Result.Err error ->
                    let
                        _ = Debug.log "error" error
                    in
                    ( model
                    , Cmd.none
                    )

        GetAccessTokens time ->
            let
                fetches =
                    model.clientCredentials
                        |> Dict.values
                        |> List.map
                            (\c ->
                                YouTubeApi.refreshAccessTokenCmd Env.clientId Env.clientSecret c.refreshToken c.email time
                            )
            in
            ( model
            , Cmd.batch fetches
            )


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
                        (model.clientCredentials |> Dict.values)
            )

        AttemptGetChannels email ->
            ( model, Cmd.none )

        AttemptGetChannelsWithTime email time ->
            ( model, Cmd.none )



-- let
--     currentTimeout =
--         model.clientCredentials |> Dict.get email
--             |> Maybe.map .timeout
--             |> Maybe.withDefault 0
--     currentAccessToken =
--         model.clientCredentials |> Dict.get email
--             |> Maybe.map .accessToken
--     currentRefreshToken =
--         model.clientCredentials |> Dict.get email
--             |> Maybe.map .refreshToken
--             |> Maybe.withDefault ""
--     stillValid =
--         (time |> Time.posixToMillis) <= currentTimeout
-- in
-- case (stillValid, currentAccessToken) of
--     (True, Just accessToken, _) ->
--         ( model
--         , Cmd.none
--         )
--     _ ->
--         ( model
--         , YouTubeApi.refreshAccessToken
--             Env.clientId
--             Env.clientSecret
--             currentRefreshToken
--             |> Task.map (\t -> t.accessToken)
--             |> Task.map (\t -> AttemptGetChannelsWithTime email time)
--             |> Task.perform (GotFreshAccessTokenWithTime email)
--         )
-- AttemptGetChannels email ->
--     let
--         timestamp =
--             model.clientCredentials |> Dict.get email
--                 |> Maybe.map .timestamp
--                 |> Maybe.map (\t -> t + 3600000)
--                 |> Maybe.withDefault 0
--         maybeCredentials =
--             model.clientCredentials |> Dict.get email
--         refreshTokens =
--             maybeCredentials |> Maybe.map .refreshToken |> Maybe.withDefault ""
--         currentAccessToken =
--             maybeCredentials |> Maybe.map .accessToken |> Maybe.withDefault ""
--         taskTimeValid taskToDo =
--             Time.now
--             |> Task.map (\now -> (now |> Time.posixToMillis) <= timestamp)
--             |> Task.andThen (\valid ->
--                 if not valid then
--                     YouTubeApi.refreshAccessToken
--                         Env.clientId
--                         Env.clientSecret
--                         refreshTokens
--                     |> Task.map (\t -> t.accessToken)
--                     |> Task.map (\t -> taskToDo t)
--                 else
--                     taskToDo currentAccessToken)
--     in
--     ( model
--     , Cmd.none
--     -- , sendToPage clientId <|
--     --     Gen.Msg.Example <|
--     --         Pages.Example.GotChannels <|
--     --             (model.clientCredentials |> Dict.get email |> Maybe.map .channels |> Maybe.withDefault [])
--     )
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
