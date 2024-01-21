module Evergreen.V51.Bridge exposing (..)

import Evergreen.V51.Api.User
import Evergreen.V51.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V51.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V51.Api.User.Email
        , password : String
        }
    | AttemptSignOut
    | AttemptGetCredentials
    | AttemptGetChannels String
    | AttemptGetVideos String
    | AttemptYeetCredentials String
    | FetchChannelsFromYoutube String
    | FetchPlaylistsFromYoutube String
    | FetchVideosFromYoutube String
    | AttemptGetChannelAndPlaylists String
    | AttemptGetLogs Int Int
    | AttemptYeetLogs
    | AttemptYeetVideos
    | AttemptGetVideoDetails String
    | AttemptBatch_RefreshAccessTokens
    | AttemptBatch_RefreshAllChannels
    | AttemptBatch_RefreshAllPlaylists
    | AttemptBatch_RefreshAllVideosFromPlaylists
    | AttemptBatch_GetLiveVideoStreamData
    | AttemptBatch_GetVideoStats
    | AttemptBatch_GetVideoDailyReports
    | AttemptBatch_GetChatMessages
    | AttemptBatch_GetVideoStatisticsAtTime
    | AttemptBatch_GetCompetitorVideos
    | AttemptBatch_ExportToSheet
    | UpdateSchedule Evergreen.V51.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V51.Api.YoutubeModel.Playlist
    | NoOpToBackend
