module Evergreen.V19.Bridge exposing (..)

import Evergreen.V19.Api.User
import Evergreen.V19.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V19.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V19.Api.User.Email
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
    | UpdateSchedule Evergreen.V19.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V19.Api.YoutubeModel.Playlist
    | NoOpToBackend
