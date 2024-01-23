module Evergreen.V66.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V66.Api.YoutubeModel
import Time


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V66.Api.YoutubeModel.Video
    , liveVideoDetails : Dict.Dict String Evergreen.V66.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V66.Api.YoutubeModel.CurrentViewers
    , videoChannels : Dict.Dict String String
    , playlists : Dict.Dict String Evergreen.V66.Api.YoutubeModel.Playlist
    , videoStats : Dict.Dict ( String, Int ) Evergreen.V66.Api.YoutubeModel.VideoStatisticsAtTime
    , competitorVideos : Dict.Dict String (Dict.Dict String Evergreen.V66.Api.YoutubeModel.Video)
    , currentIntTime : Int
    , tmpCtrs : Dict.Dict String String
    , tmpLiveViews : Dict.Dict String String
    }


type Msg
    = GotVideos Evergreen.V66.Api.YoutubeModel.VideoResults
    | GetVideos
    | UpdateVideoCTR String String
    | UpdateVideoLiveViews String String
    | Tick Time.Posix
