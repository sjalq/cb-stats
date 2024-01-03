module Bridge exposing (..)

import Api.User exposing (Email)
import Api.YoutubeModel exposing (Channel, Playlist)
import Dict exposing (Dict)
import Lamdera
import Api.YoutubeModel exposing (Schedule)


sendToBackend =
    Lamdera.sendToBackend


type ToBackend
    = AttemptRegistration { email : Email, password : String }
    | AttemptSignIn { email : Email, password : String }
    | AttemptSignOut
    | AttemptGetCredentials
    | AttemptGetChannels String
      -- front end instructions to fetch data from youtube
    | FetchChannelsFromYoutube String
    | FetchPlaylistsFromYoutube String
    | FetchVideosFromYoutube String
      -- normal fetches from backend to frontend
    | AttemptGetChannelAndPlaylists String
    | AttemptGetVideos String
    | AttemptGetLogs
    -- update from frontend
    | UpdateSchedule Schedule
    | UpdatePlaylist Playlist
    -- no op for migrations
    | NoOpToBackend
