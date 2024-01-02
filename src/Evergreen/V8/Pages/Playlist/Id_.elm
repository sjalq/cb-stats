module Evergreen.V8.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V8.Api.YoutubeModel


type alias Model =
    { playlistId : String
    , videos : Dict.Dict String Evergreen.V8.Api.YoutubeModel.Video
    }


type Msg
    = GotVideos (Dict.Dict String Evergreen.V8.Api.YoutubeModel.Video)
    | GetVideos
