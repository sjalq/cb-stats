module Evergreen.V6.Pages.Ga.Email_ exposing (..)

import Evergreen.V6.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V6.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V6.Api.YoutubeModel.Channel)
