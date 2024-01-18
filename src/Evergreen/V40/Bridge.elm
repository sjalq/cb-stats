module Evergreen.V40.Bridge exposing (..)

import Evergreen.V40.Api.User
import Evergreen.V40.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V40.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V40.Api.User.Email
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
    | UpdateSchedule Evergreen.V40.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V40.Api.YoutubeModel.Playlist
    | NoOpToBackend
