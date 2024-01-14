module Evergreen.V21.Pages.Ga.Email_ exposing (..)

import Evergreen.V21.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V21.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V21.Api.YoutubeModel.Channel)
    | GetChannels
