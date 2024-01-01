module Types exposing (..)

import Api.User exposing (Email, User, UserFull)
import Bridge
import Browser
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Http
import Lamdera exposing (ClientId, SessionId)
import Shared
import Time
import Url exposing (Url)
import Api.YoutubeModel exposing (ClientCredentials)
import Api.Logging exposing (..)
import Time exposing (Posix)
import Json.Auto.AccessToken 
import Api.YoutubeModel exposing (..)
import Json.Auto.Playlists
import Json.Auto.Channels
import Set exposing (..)
import Gen.Pages as Pages


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
    , clientCredentials : Dict String ClientCredentials
    , channels : Dict String Channel
    , channelAssociations : List ChannelAssociation
    , playlists : Dict String Playlist
    , schedules : Dict String Schedule
    , apiCallCount : Int
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
    | GotFreshAccessTokenWithTime String String Posix
    | Quota_RefreshAccessTokens Time.Posix
    | Quota_RefreshAllChannels Time.Posix
    | Quota_RefreshAllPlaylists Time.Posix
    | Quota_RefreshAllVideos Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Json.Auto.AccessToken.Root)
    | GetChannels String
    | GotChannels String (Result Http.Error Json.Auto.Channels.Root)
    | GetPlaylists String
    | GotPlaylists String (Result Http.Error Json.Auto.Playlists.Root)
    | GetVideos String
    -- | GotVideos String (Result Http.Error Json.Auto.Videos.Root)
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
