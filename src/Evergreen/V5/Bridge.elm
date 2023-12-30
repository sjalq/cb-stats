module Evergreen.V5.Bridge exposing (..)

import Evergreen.V5.Api.User


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V5.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V5.Api.User.Email
        , password : String
        }
    | AttemptSignOut
    | AttemptGetCredentials
    | AttemptGetChannels String
    | AttemptGetPlaylists String
    | NoOpToBackend
