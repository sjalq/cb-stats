module Evergreen.V12.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V12.Api.YoutubeModel


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V12.Api.YoutubeModel.Video
    }


type Msg
    = GotVideos Evergreen.V12.Api.YoutubeModel.Playlist (Dict.Dict String Evergreen.V12.Api.YoutubeModel.Video)
    | GetVideos
