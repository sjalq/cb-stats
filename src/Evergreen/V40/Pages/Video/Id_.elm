module Evergreen.V40.Pages.Video.Id_ exposing (..)

import Evergreen.V40.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V40.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V40.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V40.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V40.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
