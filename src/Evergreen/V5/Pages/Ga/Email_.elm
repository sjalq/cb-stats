module Evergreen.V5.Pages.Ga.Email_ exposing (..)

import Evergreen.V5.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V5.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V5.Api.YoutubeModel.Channel)
