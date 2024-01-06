module Evergreen.V16.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V16.Api.YoutubeModel


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V16.Api.YoutubeModel.Video
    , liveVideoDetails : Dict.Dict String Evergreen.V16.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V16.Api.YoutubeModel.CurrentViewers
    }


type Msg
    = GotVideos Evergreen.V16.Api.YoutubeModel.Playlist (Dict.Dict String Evergreen.V16.Api.YoutubeModel.Video) (Dict.Dict String Evergreen.V16.Api.YoutubeModel.LiveVideoDetails) (Dict.Dict ( String, Int ) Evergreen.V16.Api.YoutubeModel.CurrentViewers)
    | GetVideos
