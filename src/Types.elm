module Types exposing (..)

import Bridge
import Browser exposing (UrlRequest)
import Browser.Navigation exposing (Key)
import Lamdera exposing (ClientId, SessionId)
import Main as ElmLand
import Url exposing (Url)
import Time exposing (..)
import Api.Logging exposing (LogLevel, LogEntry)
import Api.ClientCredentials exposing (ClientCredentials)

type alias FrontendModel =
    ElmLand.Model




type alias BackendModel =
    { smashedLikes : Int
    , logs : List LogEntry
    , clientCredentials : Maybe ClientCredentials
    }


type alias FrontendMsg =
    ElmLand.Msg


type alias ToBackend =
    Bridge.ToBackend


type BackendMsg
    = HandleClientCredentials ClientCredentials
    | OnConnect SessionId ClientId
    | Log_ String LogLevel Time.Posix -- don't use directly, use BackendLogging.log instead



type ToFrontend
    = NewSmashedLikes Int
    | NewClientCredentials ClientCredentials
