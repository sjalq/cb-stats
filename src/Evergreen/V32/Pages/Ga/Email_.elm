module Evergreen.V32.Pages.Ga.Email_ exposing (..)

import Evergreen.V32.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V32.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V32.Api.YoutubeModel.Channel)
    | GetChannels
