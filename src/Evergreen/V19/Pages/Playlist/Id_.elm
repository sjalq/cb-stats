module Evergreen.V19.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V19.Api.YoutubeModel


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V19.Api.YoutubeModel.Video
    , liveVideoDetails : Dict.Dict String Evergreen.V19.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V19.Api.YoutubeModel.CurrentViewers
    , videoChannels : Dict.Dict String String
    }


type Msg
    = GotVideos Evergreen.V19.Api.YoutubeModel.Playlist (Dict.Dict String Evergreen.V19.Api.YoutubeModel.Video) (Dict.Dict String Evergreen.V19.Api.YoutubeModel.LiveVideoDetails) (Dict.Dict ( String, Int ) Evergreen.V19.Api.YoutubeModel.CurrentViewers) (Dict.Dict String String)
    | GetVideos
