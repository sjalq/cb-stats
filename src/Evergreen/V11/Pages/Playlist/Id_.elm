module Evergreen.V11.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V11.Api.YoutubeModel


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V11.Api.YoutubeModel.Video
    }


type Msg
    = GotVideos Evergreen.V11.Api.YoutubeModel.Playlist (Dict.Dict String Evergreen.V11.Api.YoutubeModel.Video)
    | GetVideos
