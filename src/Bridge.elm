module Bridge exposing (..)

import Api.User exposing (Email)
import Dict exposing (Dict)
import Lamdera
import Api.YoutubeModel exposing (Channel)
import Api.YoutubeModel exposing (Playlist)


sendToBackend =
    Lamdera.sendToBackend


type ToBackend
    = AttemptRegistration { email : Email, password : String }
    | AttemptSignIn { email : Email, password : String }
    | AttemptSignOut
    | AttemptGetCredentials
    | AttemptGetChannels String
    | AttemptGetChannelAndPlaylists String 
    | AttemptGetLogs
    | NoOpToBackend
