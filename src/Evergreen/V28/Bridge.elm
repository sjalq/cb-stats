module Evergreen.V28.Bridge exposing (..)

import Evergreen.V28.Api.User
import Evergreen.V28.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V28.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V28.Api.User.Email
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
    | UpdateSchedule Evergreen.V28.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V28.Api.YoutubeModel.Playlist
    | NoOpToBackend
