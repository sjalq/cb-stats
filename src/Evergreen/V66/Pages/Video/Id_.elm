module Evergreen.V66.Pages.Video.Id_ exposing (..)

import Evergreen.V66.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V66.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V66.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V66.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V66.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
