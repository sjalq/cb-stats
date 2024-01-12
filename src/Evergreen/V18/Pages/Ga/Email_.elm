module Evergreen.V18.Pages.Ga.Email_ exposing (..)

import Evergreen.V18.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V18.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V18.Api.YoutubeModel.Channel)
    | GetChannels
