module Evergreen.V71.Pages.Video.Id_ exposing (..)

import Evergreen.V71.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V71.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V71.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V71.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V71.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
