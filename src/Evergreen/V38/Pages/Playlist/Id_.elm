module Evergreen.V38.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V38.Api.YoutubeModel


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V38.Api.YoutubeModel.Video
    , liveVideoDetails : Dict.Dict String Evergreen.V38.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V38.Api.YoutubeModel.CurrentViewers
    , videoChannels : Dict.Dict String String
    , playlists : Dict.Dict String Evergreen.V38.Api.YoutubeModel.Playlist
    , videoStats : Dict.Dict ( String, Int ) Evergreen.V38.Api.YoutubeModel.VideoStatisticsAtTime
    , competitorVideos : Dict.Dict String (Dict.Dict String Evergreen.V38.Api.YoutubeModel.Video)
    }


type Msg
    = GotVideos (Dict.Dict String Evergreen.V38.Api.YoutubeModel.Playlist) (Dict.Dict String Evergreen.V38.Api.YoutubeModel.Video) (Dict.Dict String Evergreen.V38.Api.YoutubeModel.LiveVideoDetails) (Dict.Dict ( String, Int ) Evergreen.V38.Api.YoutubeModel.CurrentViewers) (Dict.Dict String String) (Dict.Dict ( String, Int ) Evergreen.V38.Api.YoutubeModel.VideoStatisticsAtTime) (Dict.Dict String (Dict.Dict String Evergreen.V38.Api.YoutubeModel.Video))
    | GetVideos
