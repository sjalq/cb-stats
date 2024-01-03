module Evergreen.V11.Bridge exposing (..)

import Evergreen.V11.Api.User
import Evergreen.V11.Api.YoutubeModel


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V11.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V11.Api.User.Email
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
    | UpdateSchedule Evergreen.V11.Api.YoutubeModel.Schedule
    | NoOpToBackend
