module Evergreen.V20.Bridge exposing (..)

import Evergreen.V20.Api.User
import Evergreen.V20.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V20.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V20.Api.User.Email
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
    | UpdateSchedule Evergreen.V20.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V20.Api.YoutubeModel.Playlist
    | NoOpToBackend
