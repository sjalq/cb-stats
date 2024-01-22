module Evergreen.V54.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V54.Api.Logging
import Evergreen.V54.Api.User
import Evergreen.V54.Api.YoutubeModel
import Evergreen.V54.Bridge
import Evergreen.V54.Gen.Pages
import Evergreen.V54.Json.Auto.AccessToken
import Evergreen.V54.Json.Auto.ChannelHandle
import Evergreen.V54.Json.Auto.Channels
import Evergreen.V54.Json.Auto.GoogleSheetsDetails
import Evergreen.V54.Json.Auto.PlaylistItems
import Evergreen.V54.Json.Auto.Playlists
import Evergreen.V54.Json.Auto.Search
import Evergreen.V54.Json.Auto.VideoStats
import Evergreen.V54.Json.Bespoke.LiveBroadcastDecoder
import Evergreen.V54.Json.Bespoke.ReportDecoder
import Evergreen.V54.Json.Bespoke.VideoDecoder
import Evergreen.V54.Shared
import Http
import Lamdera
import Set
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V54.Shared.Model
    , page : Evergreen.V54.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V54.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V54.Api.User.Email Evergreen.V54.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V54.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V54.Api.YoutubeModel.ClientCredentials
    , channels : Dict.Dict String Evergreen.V54.Api.YoutubeModel.Channel
    , channelAssociations : List Evergreen.V54.Api.YoutubeModel.ChannelAssociation
    , playlists : Dict.Dict String Evergreen.V54.Api.YoutubeModel.Playlist
    , competitors : Set.Set ( String, String )
    , schedules : Dict.Dict String Evergreen.V54.Api.YoutubeModel.Schedule
    , videos : Dict.Dict String Evergreen.V54.Api.YoutubeModel.Video
    , videoStatisticsAtTime : Dict.Dict ( String, Int ) Evergreen.V54.Api.YoutubeModel.VideoStatisticsAtTime
    , liveVideoDetails : Dict.Dict String Evergreen.V54.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V54.Api.YoutubeModel.CurrentViewers
    , channelHandleMap : List ( String, String )
    , apiCallCount : Int
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V54.Shared.Msg
    | Page Evergreen.V54.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V54.Bridge.ToBackend


type NextAction
    = DeleteSheets
    | AddSheets (List Int)
    | UpdateSheets (List Int)
    | Done


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V54.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V54.Api.Logging.LogLevel Time.Posix
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
    | Batch_GetCompetitorChannelIds Time.Posix
    | Batch_GetCompetitorVideos Time.Posix
    | Batch_ExportToSheet Time.Posix
    | GetChannelId String
    | GetAccessToken String Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V54.Json.Auto.AccessToken.Root)
    | GetChannelsByCredential String
    | GotChannels String (Result Http.Error Evergreen.V54.Json.Auto.Channels.Root)
    | GetPlaylistsByChannel String
    | GotPlaylists String (Result Http.Error Evergreen.V54.Json.Auto.Playlists.Root)
    | GetVideosByPlaylist (Maybe String) String
    | GotVideosFromPlaylist String (Result Http.Error Evergreen.V54.Json.Auto.PlaylistItems.Root)
    | GotLiveVideoStreamData Time.Posix String (Result Http.Error Evergreen.V54.Json.Bespoke.VideoDecoder.Root)
    | GotVideoStatsOnConclusion Time.Posix String (Result Http.Error Evergreen.V54.Json.Auto.VideoStats.Root)
    | GotVideoStatsAfter24Hrs Time.Posix String (Result Http.Error Evergreen.V54.Json.Auto.VideoStats.Root)
    | GotVideoStatsOnTheHour Time.Posix String (Result Http.Error Evergreen.V54.Json.Auto.VideoStats.Root)
    | GotChatMessages String (Result Http.Error Evergreen.V54.Json.Bespoke.LiveBroadcastDecoder.Root)
    | GotVideoDailyReport String (Result Http.Error Evergreen.V54.Json.Bespoke.ReportDecoder.YouTubeAnalyticsRecord)
    | GotChannelId String (Result Http.Error Evergreen.V54.Json.Auto.ChannelHandle.Root)
    | GotCompetitorVideos String (Result Http.Error Evergreen.V54.Json.Auto.Search.Root)
    | SheetUpdated String String NextAction (Result Http.Error ())
    | DeletedSheets String (List Int) NextAction (Result Http.Error ())
    | GotSheetIds String NextAction (Result Http.Error Evergreen.V54.Json.Auto.GoogleSheetsDetails.Root)
    | AddedSheets String (List String) NextAction (Result Http.Error ())
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V54.Gen.Pages.Msg
    | SharedMsg Evergreen.V54.Shared.Msg
    | NoOpToFrontend
