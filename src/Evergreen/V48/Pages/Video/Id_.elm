module Evergreen.V48.Pages.Video.Id_ exposing (..)

import Evergreen.V48.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V48.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V48.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V48.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V48.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
