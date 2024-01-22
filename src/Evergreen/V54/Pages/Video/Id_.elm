module Evergreen.V54.Pages.Video.Id_ exposing (..)

import Evergreen.V54.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V54.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V54.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V54.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V54.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
