module Evergreen.V77.Pages.Video.Id_ exposing (..)

import Evergreen.V77.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V77.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V77.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V77.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V77.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
