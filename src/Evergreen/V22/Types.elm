module Evergreen.V22.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V22.Api.Logging
import Evergreen.V22.Api.User
import Evergreen.V22.Api.YoutubeModel
import Evergreen.V22.Bridge
import Evergreen.V22.Gen.Pages
import Evergreen.V22.Json.Auto.AccessToken
import Evergreen.V22.Json.Auto.Channels
import Evergreen.V22.Json.Auto.PlaylistItems
import Evergreen.V22.Json.Auto.Playlists
import Evergreen.V22.Json.Auto.VideoStats
import Evergreen.V22.Json.Bespoke.LiveBroadcastDecoder
import Evergreen.V22.Json.Bespoke.ReportDecoder
import Evergreen.V22.Json.Bespoke.VideoDecoder
import Evergreen.V22.Shared
import Http
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V22.Shared.Model
    , page : Evergreen.V22.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V22.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V22.Api.User.Email Evergreen.V22.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V22.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V22.Api.YoutubeModel.ClientCredentials
    , channels : Dict.Dict String Evergreen.V22.Api.YoutubeModel.Channel
    , channelAssociations : List Evergreen.V22.Api.YoutubeModel.ChannelAssociation
    , playlists : Dict.Dict String Evergreen.V22.Api.YoutubeModel.Playlist
    , schedules : Dict.Dict String Evergreen.V22.Api.YoutubeModel.Schedule
    , videos : Dict.Dict String Evergreen.V22.Api.YoutubeModel.Video
    , videoStatisticsAtTime : Dict.Dict ( String, Int ) Evergreen.V22.Api.YoutubeModel.VideoStatisticsAtTime
    , liveVideoDetails : Dict.Dict String Evergreen.V22.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V22.Api.YoutubeModel.CurrentViewers
    , apiCallCount : Int
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V22.Shared.Msg
    | Page Evergreen.V22.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V22.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V22.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V22.Api.Logging.LogLevel Time.Posix
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
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V22.Json.Auto.AccessToken.Root)
    | GetChannelsByCredential String
    | GotChannels String (Result Http.Error Evergreen.V22.Json.Auto.Channels.Root)
    | GetPlaylistsByChannel String
    | GotPlaylists String (Result Http.Error Evergreen.V22.Json.Auto.Playlists.Root)
    | GetVideosByPlaylist (Maybe String) String
    | GotVideosFromPlaylist String (Result Http.Error Evergreen.V22.Json.Auto.PlaylistItems.Root)
    | GotLiveVideoStreamData Time.Posix String (Result Http.Error Evergreen.V22.Json.Bespoke.VideoDecoder.Root)
    | GotVideoStatsOnConclusion Time.Posix String (Result Http.Error Evergreen.V22.Json.Bespoke.VideoDecoder.Root)
    | GotVideoStatsAfter24Hrs Time.Posix String (Result Http.Error Evergreen.V22.Json.Bespoke.VideoDecoder.Root)
    | GotVideoStatsOnTheHour Time.Posix String (Result Http.Error Evergreen.V22.Json.Auto.VideoStats.Root)
    | GotChatMessages String (Result Http.Error Evergreen.V22.Json.Bespoke.LiveBroadcastDecoder.Root)
    | GotVideoDailyReport String (Result Http.Error Evergreen.V22.Json.Bespoke.ReportDecoder.YouTubeAnalyticsRecord)
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V22.Gen.Pages.Msg
    | SharedMsg Evergreen.V22.Shared.Msg
    | NoOpToFrontend
