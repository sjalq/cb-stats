module Evergreen.V26.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V26.Api.Logging
import Evergreen.V26.Api.User
import Evergreen.V26.Api.YoutubeModel
import Evergreen.V26.Bridge
import Evergreen.V26.Gen.Pages
import Evergreen.V26.Json.Auto.AccessToken
import Evergreen.V26.Json.Auto.Channels
import Evergreen.V26.Json.Auto.PlaylistItems
import Evergreen.V26.Json.Auto.Playlists
import Evergreen.V26.Json.Auto.VideoStats
import Evergreen.V26.Json.Bespoke.LiveBroadcastDecoder
import Evergreen.V26.Json.Bespoke.ReportDecoder
import Evergreen.V26.Json.Bespoke.VideoDecoder
import Evergreen.V26.Shared
import Http
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V26.Shared.Model
    , page : Evergreen.V26.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V26.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V26.Api.User.Email Evergreen.V26.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V26.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V26.Api.YoutubeModel.ClientCredentials
    , channels : Dict.Dict String Evergreen.V26.Api.YoutubeModel.Channel
    , channelAssociations : List Evergreen.V26.Api.YoutubeModel.ChannelAssociation
    , playlists : Dict.Dict String Evergreen.V26.Api.YoutubeModel.Playlist
    , schedules : Dict.Dict String Evergreen.V26.Api.YoutubeModel.Schedule
    , videos : Dict.Dict String Evergreen.V26.Api.YoutubeModel.Video
    , videoStatisticsAtTime : Dict.Dict ( String, Int ) Evergreen.V26.Api.YoutubeModel.VideoStatisticsAtTime
    , liveVideoDetails : Dict.Dict String Evergreen.V26.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V26.Api.YoutubeModel.CurrentViewers
    , apiCallCount : Int
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V26.Shared.Msg
    | Page Evergreen.V26.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V26.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V26.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V26.Api.Logging.LogLevel Time.Posix
    | GotFreshAccessTokenWithTime String String Time.Posix
    | Batch_RefreshAccessTokens Time.Posix
    | Batch_RefreshAllChannels Time.Posix
    | Batch_RefreshAllPlaylists Time.Posix
    | Batch_RefreshAllVideosFromPlaylists Time.Posix
    | Batch_GetLiveVideoStreamData Time.Posix
    | Batch_GetChatMessages Time.Posix
    | Batch_GetVideoStats Time.Posix
    | Batch_GetVideoDailyReports Time.Posix
    | Batch_GetVideoStatisticsAtTime Time.Posix
    | GetAccessToken String Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V26.Json.Auto.AccessToken.Root)
    | GetChannelsByCredential String
    | GotChannels String (Result Http.Error Evergreen.V26.Json.Auto.Channels.Root)
    | GetPlaylistsByChannel String
    | GotPlaylists String (Result Http.Error Evergreen.V26.Json.Auto.Playlists.Root)
    | GetVideosByPlaylist (Maybe String) String
    | GotVideosFromPlaylist String (Result Http.Error Evergreen.V26.Json.Auto.PlaylistItems.Root)
    | GotLiveVideoStreamData Time.Posix String (Result Http.Error Evergreen.V26.Json.Bespoke.VideoDecoder.Root)
    | GotVideoStatsOnConclusion Time.Posix String (Result Http.Error Evergreen.V26.Json.Auto.VideoStats.Root)
    | GotVideoStatsAfter24Hrs Time.Posix String (Result Http.Error Evergreen.V26.Json.Auto.VideoStats.Root)
    | GotVideoStatsOnTheHour Time.Posix String (Result Http.Error Evergreen.V26.Json.Auto.VideoStats.Root)
    | GotChatMessages String (Result Http.Error Evergreen.V26.Json.Bespoke.LiveBroadcastDecoder.Root)
    | GotVideoDailyReport String (Result Http.Error Evergreen.V26.Json.Bespoke.ReportDecoder.YouTubeAnalyticsRecord)
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V26.Gen.Pages.Msg
    | SharedMsg Evergreen.V26.Shared.Msg
    | NoOpToFrontend
