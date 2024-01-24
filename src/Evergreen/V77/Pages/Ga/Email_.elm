module Evergreen.V77.Pages.Ga.Email_ exposing (..)

import Evergreen.V77.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V77.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V77.Api.YoutubeModel.Channel)
    | GetChannels
