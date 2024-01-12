module Evergreen.V18.Bridge exposing (..)

import Evergreen.V18.Api.User
import Evergreen.V18.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V18.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V18.Api.User.Email
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
    | UpdateSchedule Evergreen.V18.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V18.Api.YoutubeModel.Playlist
    | NoOpToBackend
