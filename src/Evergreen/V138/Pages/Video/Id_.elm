module Evergreen.V138.Pages.Video.Id_ exposing (..)

import Evergreen.V138.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V138.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V138.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V138.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V138.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
