module Evergreen.V19.Pages.Ga.Email_ exposing (..)

import Evergreen.V19.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V19.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V19.Api.YoutubeModel.Channel)
    | GetChannels
