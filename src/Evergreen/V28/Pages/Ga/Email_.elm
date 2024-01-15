module Evergreen.V28.Pages.Ga.Email_ exposing (..)

import Evergreen.V28.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V28.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V28.Api.YoutubeModel.Channel)
    | GetChannels
