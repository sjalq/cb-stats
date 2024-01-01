module Evergreen.V6.Bridge exposing (..)

import Evergreen.V6.Api.User


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V6.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V6.Api.User.Email
        , password : String
        }
    | AttemptSignOut
    | AttemptGetCredentials
    | AttemptGetChannels String
    | AttemptGetChannelAndPlaylists String
    | AttemptGetLogs
    | NoOpToBackend
