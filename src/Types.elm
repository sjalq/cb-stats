module Types exposing (..)

import Api.Logging exposing (..)
import Api.User exposing (Email, User, UserFull)
import Api.YoutubeModel exposing (..)
import Bridge
import Browser
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Gen.Pages as Pages
import Http
import Json.Auto.AccessToken
import Json.Auto.Channels
import Json.Auto.Playlists
import Json.Auto.PlaylistItems
import Lamdera exposing (ClientId, SessionId)
import Set exposing (..)
import Shared
import Time exposing (Posix)
import Url exposing (Url)
import Json.Bespoke.VideoDecoder
import Json.Bespoke.LiveBroadcastDecoder
import Json.Bespoke.ReportDecoder


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
    , videos : Dict String Video
    , liveVideoDetails : Dict String LiveVideoDetails
    , currentViewers : Dict (String, Int) CurrentViewers
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
      -- batch calls to youtube api
    | Batch_RefreshAccessTokens Time.Posix
    | Batch_RefreshAllChannels Time.Posix
    | Batch_RefreshAllPlaylists Time.Posix
    | Batch_RefreshAllVideos Time.Posix
    | Batch_GetLiveVideoStreamData Time.Posix
    | Batch_GetChatMessages Time.Posix
    | Batch_GetVideoStats Time.Posix
    | Batch_GetVideoDailyReports Time.Posix
      -- youtube calls and responses
    | GetAccessToken String Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Json.Auto.AccessToken.Root)
    | GetChannelsByCredential String
    | GotChannels String (Result Http.Error Json.Auto.Channels.Root)
    | GetPlaylistsByChannel String
    | GotPlaylists String (Result Http.Error Json.Auto.Playlists.Root)
    | GetVideosByPlaylist (Maybe String) String 
    | GotVideosFromPlaylist String (Result Http.Error Json.Auto.PlaylistItems.Root)
    | GotLiveVideoStreamData Posix String (Result Http.Error Json.Bespoke.VideoDecoder.Root)
    | GotVideoStatsOnConclusion Posix String (Result Http.Error Json.Bespoke.VideoDecoder.Root)
    | GotVideoStatsAfter24Hrs Posix String (Result Http.Error Json.Bespoke.VideoDecoder.Root)
    | GotChatMessages String (Result Http.Error Json.Bespoke.LiveBroadcastDecoder.Root)
    | GotVideoDailyReport String (Result Http.Error Json.Bespoke.ReportDecoder.YouTubeAnalyticsRecord)
      -- other
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
