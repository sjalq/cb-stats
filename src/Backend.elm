module Backend exposing (..)

import Api.Data
import Api.Logging as Logging exposing (..)
import Api.PerformNow exposing (performNow, performNowWithTime)
import Api.User
import BackendLogging exposing (log)
import Bridge exposing (..)
import Crypto.Hash
import Dict
import Dict.Extra as Dict
import Env
import Gen.Msg
import Http exposing (Error(..))
import Lamdera exposing (..)
import List.Extra
import Pages.Channel.Id_
import Pages.Example
import Pages.Ga.Email_
import Pages.Log
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



-- todo:
-- * add error logging for any and all external calls


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
      , channels = Dict.empty
      , channelAssociations = []
      , playlists = Dict.empty
      }
    , Cmd.batch <|
        [ performNowWithTime RefreshAccessTokens
        , performNowWithTime RefreshAllChannels
        , performNowWithTime RefreshAllPlaylists
        ]
    )


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Time.every 1800000 RefreshAccessTokens -- 30 minutes
        , Time.every 10000 RefreshAllChannels -- 1 minute
        , Time.every 10000 RefreshAllPlaylists -- 1 minute
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
                    ( model
                    , Cmd.none
                    )
                        |> log ("Failed to fetch access token for " ++ email ++ "\n" ++ httpErrToString error) Error

        RefreshAccessTokens time ->
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

        GetChannels email ->
            let
                maybeAccessToken =
                    model.clientCredentials
                        |> Dict.get email
                        |> Maybe.map .accessToken

                fetch =
                    maybeAccessToken
                        |> Maybe.map
                            (\accessToken ->
                                YouTubeApi.getChannelsCmd email accessToken
                            )
                        |> Maybe.withDefault Cmd.none
            in
            ( model
            , fetch
            )

        GotChannels email channelResponse ->
            case channelResponse of
                Result.Ok channels ->
                    let
                        retrievedChannels =
                            channels.items
                                |> List.map
                                    (\c ->
                                        ( c.id
                                        , { id = c.id
                                          , title = c.snippet.title
                                          , description = c.snippet.description
                                          , customUrl = c.snippet.customUrl
                                          }
                                        )
                                    )
                                |> Dict.fromList

                        newChannels =
                            Dict.union retrievedChannels model.channels

                        newChannelAssociations =
                            retrievedChannels
                                |> Dict.keys
                                |> List.map (\channelId -> { email = email, channelId = channelId })
                                |> (++) model.channelAssociations
                                |> List.Extra.uniqueBy (\c -> c.email ++ ", " ++ c.channelId)

                        newModel =
                            { model
                                | channels = newChannels
                                , channelAssociations = newChannelAssociations
                            }
                    in
                    ( newModel
                    , Cmd.none
                    )

                Result.Err error ->
                    ( model
                    , Cmd.none
                    )
                        |> log ("Failed to fetch channels for : " ++ email ++ "\n" ++ httpErrToString error) Error

        GetPlaylists channelId ->
            let
                maybeAccessToken =
                    model.channelAssociations
                        |> List.filter (\c -> c.channelId == channelId)
                        |> List.head
                        |> Maybe.map .email
                        |> Maybe.andThen (\email -> model.clientCredentials |> Dict.get email |> Maybe.map .accessToken)

                fetch =
                    maybeAccessToken
                        |> Maybe.map
                            (\accessToken ->
                                YouTubeApi.getPlaylistsCmd channelId accessToken
                            )
                        |> Maybe.withDefault Cmd.none
            in
            ( model
            , fetch
            )

        GotPlaylists channelId playlistResponse ->
            case playlistResponse of
                Result.Ok playlists ->
                    let
                        retrievedPlaylists =
                            playlists.items
                                |> List.map
                                    (\p ->
                                        ( p.id
                                        , { id = p.id
                                          , title = p.snippet.title
                                          , description = p.snippet.description
                                          , channelId = p.snippet.channelId
                                          }
                                        )
                                    )
                                |> Dict.fromList
                            |> Debug.log "retrieved playlists"

                        newPlaylists =
                            Dict.union retrievedPlaylists model.playlists
                            |> Debug.log "new playlists"

                        newModel =
                            { model
                                | playlists = newPlaylists
                            }
                    in
                    ( newModel
                    , Cmd.none
                    )

                Result.Err error ->
                    ( model
                    , Cmd.none
                    )
                        |> log ("Failed to fetch playlists for channel : " ++ channelId ++ "\n" ++ httpErrToString error) Error

        RefreshAllChannels _ ->
            let
                fetches =
                    model.clientCredentials
                        |> Dict.keys
                        |> List.map GetChannels
                        |> List.map performNow
            in
            ( model, fetches |> Cmd.batch )

        RefreshAllPlaylists _ ->
            let
                fetches =
                    model.channels
                        |> Dict.keys
                        |> List.map GetPlaylists
                        |> List.map performNow
            in
            ( model, fetches |> Cmd.batch )


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
                            , performNowWithTime (AuthenticateSession sessionId clientId <| Api.User.toUser existingUser)
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
            let
                channelAssociations =
                    model.channelAssociations
                        |> List.filter (\c -> c.email == email)
                        |> List.map .channelId

                channels =
                    model.channels
                        |> Dict.filter (\k _ -> List.member k channelAssociations)
                        |> Dict.values
            in
            ( model
            , sendToPage clientId <|
                Gen.Msg.Ga__Email_ <|
                    Pages.Ga.Email_.GotChannels <|
                        channels
            )

        AttemptGetChannelAndPlaylists channelId ->
            let
                channel =
                    model.channels
                        |> Dict.get channelId
                        |> Debug.log "channel"

                _ = Debug.log "all playlists" model.playlists

                playlists =
                    model.playlists
                        |> Dict.filter (\_ v -> v.channelId == channelId)
                        |> Dict.values
                        |> Debug.log "playlists" 
            in
            case channel of
                Just channel_ ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Channel__Id_ <|
                            Pages.Channel.Id_.GotChannelAndPlaylists channel_ playlists
                    ) |> log ("Found channel with id: " ++ channelId ++ " Playlists retrieved = " ++ ( playlists |> List.length |> String.fromInt)) Info

                Nothing ->
                    ( model, Cmd.none ) |> log ("Failed to find channel with id: " ++ channelId) Error

        AttemptGetLogs ->
            ( model
            , sendToPage clientId <|
                Gen.Msg.Log <|
                    Pages.Log.GotLogs <|
                        model.logs
            )


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


httpErrToString : Error -> String
httpErrToString error =
    "HTTP Error - "
        ++ (case error of
                BadUrl url ->
                    "Bad URL: " ++ url

                Timeout ->
                    "Timeout occurred"

                NetworkError ->
                    "Network error occurred"

                BadStatus statusCode ->
                    "Bad status code: " ++ String.fromInt statusCode

                BadBody message ->
                    "Bad body: " ++ message
           )
