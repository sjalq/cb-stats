module Evergreen.V94.Pages.Video.Id_ exposing (..)

import Evergreen.V94.Api.YoutubeModel


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Evergreen.V94.Api.YoutubeModel.Video
    , liveVideoDetails : Maybe Evergreen.V94.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : List Evergreen.V94.Api.YoutubeModel.CurrentViewers
    , videoStatisticsAtTime : List Evergreen.V94.Api.YoutubeModel.VideoStatisticsAtTime
    }


type Msg
    = ReplaceMe
    | GotVideoDetails Model
