module Evergreen.V51.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V51.Api.YoutubeModel
import Time


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V51.Api.YoutubeModel.Video
    , liveVideoDetails : Dict.Dict String Evergreen.V51.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V51.Api.YoutubeModel.CurrentViewers
    , videoChannels : Dict.Dict String String
    , playlists : Dict.Dict String Evergreen.V51.Api.YoutubeModel.Playlist
    , videoStats : Dict.Dict ( String, Int ) Evergreen.V51.Api.YoutubeModel.VideoStatisticsAtTime
    , competitorVideos : Dict.Dict String (Dict.Dict String Evergreen.V51.Api.YoutubeModel.Video)
    , currentIntTime : Int
    }


type Msg
    = GotVideos Evergreen.V51.Api.YoutubeModel.VideoResults
    | GetVideos
    | Tick Time.Posix
