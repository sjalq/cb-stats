module Evergreen.V16.Bridge exposing (..)

import Evergreen.V16.Api.User
import Evergreen.V16.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V16.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V16.Api.User.Email
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
    | UpdateSchedule Evergreen.V16.Api.YoutubeModel.Schedule
    | UpdatePlaylist Evergreen.V16.Api.YoutubeModel.Playlist
    | NoOpToBackend
