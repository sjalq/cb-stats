module Evergreen.V1.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V1.Api.ClientCredentials
import Evergreen.V1.Api.Logging
import Evergreen.V1.Api.User
import Evergreen.V1.Bridge
import Evergreen.V1.Gen.Pages
import Evergreen.V1.Shared
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V1.Shared.Model
    , page : Evergreen.V1.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V1.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V1.Api.User.Email Evergreen.V1.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V1.Api.Logging.LogEntry
    , clientCredentials : List Evergreen.V1.Api.ClientCredentials.ClientCredentials
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V1.Shared.Msg
    | Page Evergreen.V1.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V1.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V1.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V1.Api.Logging.LogLevel Time.Posix
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V1.Gen.Pages.Msg
    | SharedMsg Evergreen.V1.Shared.Msg
    | NoOpToFrontend
