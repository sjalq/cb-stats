module Evergreen.V37.Pages.Ga.Email_ exposing (..)

import Evergreen.V37.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V37.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V37.Api.YoutubeModel.Channel)
    | GetChannels
