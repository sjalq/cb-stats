module Evergreen.V78.Pages.Video.Id_ exposing (..)

import Evergreen.V78.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V78.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V78.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V78.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V78.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
