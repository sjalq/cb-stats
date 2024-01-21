module Evergreen.V51.Pages.Log exposing (..)

import Evergreen.V51.Api.Logging


type alias Model =
    { logs : List Evergreen.V51.Api.Logging.LogEntry
    , logIndex : Int
    }


type Msg
    = GotLogs Int (List Evergreen.V51.Api.Logging.LogEntry)
    | GetLogPage Int Int
    | YeetLogs
    | YeetVideos
    | Batch_RefreshAccessTokens
    | Batch_RefreshAllChannels
    | Batch_RefreshAllPlaylists
    | Batch_RefreshAllVideosFromPlaylists
    | Batch_GetLiveVideoStreamData
    | Batch_GetVideoStats
    | Batch_GetVideoDailyReports
    | Batch_GetChatMessages
    | Batch_GetVideoStatisticsAtTime
    | Batch_GetCompetitorVideos
    | Batch_ExportToSheet
