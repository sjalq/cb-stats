module Evergreen.V71.Pages.Ga.Email_ exposing (..)

import Evergreen.V71.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V71.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V71.Api.YoutubeModel.Channel)
    | GetChannels
