module Evergreen.V50.Pages.Video.Id_ exposing (..)

import Evergreen.V50.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V50.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V50.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V50.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V50.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
