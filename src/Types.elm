module Types exposing (..)

import Api.User exposing (Email, User, UserFull)
import Bridge
import Browser
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Gen.Pages as Pages
import Http
import Lamdera exposing (ClientId, SessionId)
import Shared
import Time
import Url exposing (Url)
import Api.ClientCredentials exposing (ClientCredentials)
import Api.Logging exposing (..)


type alias FrontendModel =
    { url : Url
    , key : Key
    , shared : Shared.Model
    , page : Pages.Model
    }


type alias BackendModel =
    { users : Dict Email UserFull
    , authenticatedSessions : Dict SessionId Session
    , incrementedInt : Int
    , logs : List LogEntry
    , clientCredentials : List ClientCredentials
    }


type FrontendMsg
    = ChangedUrl Url
    | ClickedLink Browser.UrlRequest
    | Shared Shared.Msg
    | Page Pages.Msg
    | Noop


type alias ToBackend =
    Bridge.ToBackend


type BackendMsg
    = OnConnect SessionId ClientId
    | AuthenticateSession SessionId ClientId User Time.Posix
    | VerifySession SessionId ClientId Time.Posix
    | RegisterUser SessionId ClientId { email : String, password : String } String
    | Log_ String LogLevel Time.Posix -- don't use directly, use BackendLogging.log instead
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Pages.Msg
    | SharedMsg Shared.Msg
    | NoOpToFrontend


type alias Session =
    { user : Email
    , expires : Time.Posix
    }


hasExpired : Time.Posix -> Session -> Bool
hasExpired now session =
    Time.posixToMillis now >= Time.posixToMillis session.expires
