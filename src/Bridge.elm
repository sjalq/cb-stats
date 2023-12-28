module Bridge exposing (..)

import Api.User exposing (Email)
import Dict exposing (Dict)
import Lamdera
import Time


sendToBackend =
    Lamdera.sendToBackend


type ToBackend
    = AttemptRegistration { email : Email, password : String }
    | AttemptSignIn { email : Email, password : String }
    | AttemptSignOut
    | AttemptGetCredentials
    | AttemptGetChannels String
    | AttemptGetChannelsWithTime String Time.Posix
    | NoOpToBackend
