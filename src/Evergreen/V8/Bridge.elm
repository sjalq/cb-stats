module Evergreen.V8.Bridge exposing (..)

import Evergreen.V8.Api.User
import Evergreen.V8.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V8.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V8.Api.User.Email
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
    | UpdateSchedule Evergreen.V8.Api.YoutubeModel.Schedule
    | NoOpToBackend
