module Evergreen.V4.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V4.Api.ClientCredentials
import Evergreen.V4.Api.Logging
import Evergreen.V4.Api.User
import Evergreen.V4.Bridge
import Evergreen.V4.Gen.Pages
import Evergreen.V4.Json.Auto.AccessToken
import Evergreen.V4.Shared
import Http
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V4.Shared.Model
    , page : Evergreen.V4.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V4.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V4.Api.User.Email Evergreen.V4.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V4.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V4.Api.ClientCredentials.ClientCredentials
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V4.Shared.Msg
    | Page Evergreen.V4.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V4.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V4.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V4.Api.Logging.LogLevel Time.Posix
    | FetchChannels String
    | FetchAccessToken String
    | GotAccessTokenResponse String Evergreen.V4.Json.Auto.AccessToken.Root
    | GotFreshAccessTokenWithTime String String Time.Posix
    | GetAccessTokens Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V4.Json.Auto.AccessToken.Root)
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V4.Gen.Pages.Msg
    | SharedMsg Evergreen.V4.Shared.Msg
    | NoOpToFrontend
