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
import Json.Auto.ChannelHandle
import Json.Auto.Channels
import Json.Auto.PlaylistItems
import Json.Auto.Playlists
import Json.Auto.VideoStats
import Json.Auto.Search
import Json.Bespoke.LiveBroadcastDecoder
import Json.Bespoke.ReportDecoder
import Json.Bespoke.VideoDecoder
import Lamdera exposing (ClientId, SessionId)
import Set exposing (..)
import Shared
import Time exposing (Posix)
import Url exposing (Url)
import Json.Auto.GoogleSheetsUpdate
import Json.Auto.GoogleSheetsDetails

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
    , competitors : Set ( String, String )
    , schedules : Dict String Schedule
    , videos : Dict String Video
    , videoStatisticsAtTime : Dict ( String, Int ) VideoStatisticsAtTime
    , liveVideoDetails : Dict String LiveVideoDetails
    , currentViewers : Dict ( String, Int ) CurrentViewers
    , channelHandleMap : List (String, String)
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
    | Batch_RefreshAllVideosFromPlaylists Time.Posix
    | Batch_GetLiveVideoStreamData Time.Posix
    | Batch_GetChatMessages Time.Posix
    | Batch_GetVideoStats Time.Posix
    | Batch_GetVideoDailyReports Time.Posix
    | Batch_GetVideoStatisticsAtTime Time.Posix
    | Batch_GetCompetitorChannelIds Time.Posix
    | Batch_GetCompetitorVideos Time.Posix
    | Batch_ExportToSheet Time.Posix
      -- api calls
    | GetChannelId String 
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
    | GotVideoStatsOnConclusion Posix String (Result Http.Error Json.Auto.VideoStats.Root)
    | GotVideoStatsAfter24Hrs Posix String (Result Http.Error Json.Auto.VideoStats.Root)
    | GotVideoStatsOnTheHour Posix String (Result Http.Error Json.Auto.VideoStats.Root)
    | GotChatMessages String (Result Http.Error Json.Bespoke.LiveBroadcastDecoder.Root)
    | GotVideoDailyReport String (Result Http.Error Json.Bespoke.ReportDecoder.YouTubeAnalyticsRecord)
    | GotChannelId String (Result Http.Error Json.Auto.ChannelHandle.Root)
    | GotCompetitorVideos String (Result Http.Error Json.Auto.Search.Root)
    -- google sheet related messages
    | GotSheets String (Result Http.Error (List Json.Auto.GoogleSheetsDetails.Root))
    | SheetUpdated String String (Result Http.Error ())
    | DeletedSheets String (List String) (Result Http.Error ())
    | GotSheetIds String (Result Http.Error Json.Auto.GoogleSheetsDetails.Root)
    | AddedSheets String (List String) (Result Http.Error ())
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
