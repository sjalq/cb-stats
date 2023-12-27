module Evergreen.V1.Bridge exposing (..)

import Evergreen.V1.Api.User


type ToBackend
    = AttemptRegistration
        { email : Evergreen.V1.Api.User.Email
        , password : String
        }
    | AttemptSignIn
        { email : Evergreen.V1.Api.User.Email
        , password : String
        }
    | AttemptSignOut
    | AttemptGetCredentials
    | NoOpToBackend
