module Bridge exposing (..)

import Api.User exposing (Email)
import Dict exposing (Dict)
import Lamdera


sendToBackend =
    Lamdera.sendToBackend


type ToBackend
    = AttemptRegistration { email : Email, password : String }
    | AttemptSignIn { email : Email, password : String }
    | AttemptSignOut
    | AttemptGetCredentials
    | NoOpToBackend
