module Evergreen.V38.Bridge exposing (..)

import Evergreen.V38.Api.User
import Evergreen.V38.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V38.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V38.Api.User.Email
        , password : String
        }
    | AttemptSignOut
    | AttemptGetCredentials
    | AttemptGetChannels String
    | AttemptYeetCredentials String
    | FetchChannelsFromYoutube String
    | FetchPlaylistsFromYoutube String
    | FetchVideosFromYoutube String
    | AttemptGetChannelAndPlaylists String
    | AttemptGetVideos String
    | AttemptGetLogs Int Int
    | AttemptYeetLogs
    | AttemptYeetVideos
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
    | UpdateSchedule Evergreen.V38.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V38.Api.YoutubeModel.Playlist
    | NoOpToBackend
