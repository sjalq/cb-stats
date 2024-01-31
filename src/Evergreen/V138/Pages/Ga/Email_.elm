module Evergreen.V138.Pages.Ga.Email_ exposing (..)

import Evergreen.V138.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V138.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V138.Api.YoutubeModel.Channel)
    | GetChannels
