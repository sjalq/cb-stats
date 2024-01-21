module Evergreen.V51.Pages.Video.Id_ exposing (..)

import Evergreen.V51.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V51.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V51.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V51.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V51.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
