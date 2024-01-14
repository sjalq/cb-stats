module Evergreen.V21.Bridge exposing (..)

import Evergreen.V21.Api.User
import Evergreen.V21.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V21.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V21.Api.User.Email
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
    | UpdateSchedule Evergreen.V21.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V21.Api.YoutubeModel.Playlist
    | NoOpToBackend
