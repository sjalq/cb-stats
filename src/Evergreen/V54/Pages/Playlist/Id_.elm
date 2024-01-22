module Evergreen.V54.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V54.Api.YoutubeModel
import Time


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V54.Api.YoutubeModel.Video
    , liveVideoDetails : Dict.Dict String Evergreen.V54.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V54.Api.YoutubeModel.CurrentViewers
    , videoChannels : Dict.Dict String String
    , playlists : Dict.Dict String Evergreen.V54.Api.YoutubeModel.Playlist
    , videoStats : Dict.Dict ( String, Int ) Evergreen.V54.Api.YoutubeModel.VideoStatisticsAtTime
    , competitorVideos : Dict.Dict String (Dict.Dict String Evergreen.V54.Api.YoutubeModel.Video)
    , currentIntTime : Int
    }


type Msg
    = GotVideos Evergreen.V54.Api.YoutubeModel.VideoResults
    | GetVideos
    | Tick Time.Posix
