module Evergreen.V37.Bridge exposing (..)

import Evergreen.V37.Api.User
import Evergreen.V37.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V37.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V37.Api.User.Email
        , password : String
        }
    | AttemptSignOut
    | AttemptGetCredentials
    | AttemptGetChannels String
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
    | UpdateSchedule Evergreen.V37.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V37.Api.YoutubeModel.Playlist
    | NoOpToBackend
