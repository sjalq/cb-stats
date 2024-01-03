module Evergreen.V12.Bridge exposing (..)

import Evergreen.V12.Api.User
import Evergreen.V12.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V12.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V12.Api.User.Email
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
    | AttemptGetLogs
    | UpdateSchedule Evergreen.V12.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V12.Api.YoutubeModel.Playlist
    | NoOpToBackend
