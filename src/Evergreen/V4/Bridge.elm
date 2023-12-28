module Evergreen.V4.Bridge exposing (..)

import Evergreen.V4.Api.User
import Time


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V4.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V4.Api.User.Email
        , password : String
        }
    | AttemptSignOut
    | AttemptGetCredentials
    | AttemptGetChannels String
    | AttemptGetChannelsWithTime String Time.Posix
    | NoOpToBackend
