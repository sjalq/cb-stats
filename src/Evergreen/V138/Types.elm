module Evergreen.V138.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V138.Api.Logging
import Evergreen.V138.Api.User
import Evergreen.V138.Api.YoutubeModel
import Evergreen.V138.Bridge
import Evergreen.V138.Gen.Pages
import Evergreen.V138.Json.Auto.AccessToken
import Evergreen.V138.Json.Auto.ChannelHandle
import Evergreen.V138.Json.Auto.Channels
import Evergreen.V138.Json.Auto.GoogleSheetsDetails
import Evergreen.V138.Json.Auto.PlaylistItems
import Evergreen.V138.Json.Auto.Playlists
import Evergreen.V138.Json.Auto.Search
import Evergreen.V138.Json.Auto.VideoStats
import Evergreen.V138.Json.Bespoke.LiveBroadcastDecoder
import Evergreen.V138.Json.Bespoke.ReportDecoder
import Evergreen.V138.Json.Bespoke.VideoDecoder
import Evergreen.V138.Shared
import Http
import Lamdera
import Set
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V138.Shared.Model
    , page : Evergreen.V138.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V138.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V138.Api.User.Email Evergreen.V138.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V138.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V138.Api.YoutubeModel.ClientCredentials
    , channels : Dict.Dict String Evergreen.V138.Api.YoutubeModel.Channel
    , channelAssociations : List Evergreen.V138.Api.YoutubeModel.ChannelAssociation
    , playlists : Dict.Dict String Evergreen.V138.Api.YoutubeModel.Playlist
    , competitors : Set.Set ( String, String )
    , schedules : Dict.Dict String Evergreen.V138.Api.YoutubeModel.Schedule
    , videos : Dict.Dict String Evergreen.V138.Api.YoutubeModel.Video
    , videoStatisticsAtTime : Dict.Dict ( String, Int ) Evergreen.V138.Api.YoutubeModel.VideoStatisticsAtTime
    , liveVideoDetails : Dict.Dict String Evergreen.V138.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V138.Api.YoutubeModel.CurrentViewers
    , channelHandleMap : List ( String, String )
    , apiCallCount : Int
    , time : Time.Posix
    , greetingStr : String
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V138.Shared.Msg
    | Page Evergreen.V138.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V138.Bridge.ToBackend


type NextAction
    = DeleteSheets
    | AddSheets (List Int)
    | UpdateSheets (List Int)
    | Done


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V138.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V138.Api.Logging.LogLevel Time.Posix
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
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V138.Json.Auto.AccessToken.Root)
    | GetChannelsByCredential String
    | GotChannels String (Result Http.Error Evergreen.V138.Json.Auto.Channels.Root)
    | GetPlaylistsByChannel String
    | GotPlaylists String (Result Http.Error Evergreen.V138.Json.Auto.Playlists.Root)
    | GetVideosByPlaylist (Maybe String) String
    | GotVideosFromPlaylist String (Result Http.Error Evergreen.V138.Json.Auto.PlaylistItems.Root)
    | GotLiveVideoStreamData Time.Posix String (Result Http.Error Evergreen.V138.Json.Bespoke.VideoDecoder.Root)
    | GotVideoStatsOnConclusion Time.Posix String (Result Http.Error Evergreen.V138.Json.Auto.VideoStats.Root)
    | GotVideoStatsAfter24Hrs Time.Posix String (Result Http.Error Evergreen.V138.Json.Auto.VideoStats.Root)
    | GotVideoStatsOnTheHour Time.Posix String (Result Http.Error Evergreen.V138.Json.Auto.VideoStats.Root)
    | GotChatMessages String (Result Http.Error Evergreen.V138.Json.Bespoke.LiveBroadcastDecoder.Root)
    | GotVideoDailyReport String (Result Http.Error Evergreen.V138.Json.Bespoke.ReportDecoder.YouTubeAnalyticsRecord)
    | GotChannelId String (Result Http.Error Evergreen.V138.Json.Auto.ChannelHandle.Root)
    | GotCompetitorVideos String (Result Http.Error Evergreen.V138.Json.Auto.Search.Root)
    | SheetUpdated String String NextAction (Result Http.Error ())
    | DeletedSheets String (List Int) NextAction (Result Http.Error ())
    | GotSheetIds String NextAction (Result Http.Error Evergreen.V138.Json.Auto.GoogleSheetsDetails.Root)
    | AddedSheets String (List String) NextAction (Result Http.Error ())
    | Tick Time.Posix
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V138.Gen.Pages.Msg
    | SharedMsg Evergreen.V138.Shared.Msg
    | NoOpToFrontend
