module Evergreen.V39.Pages.Ga.Email_ exposing (..)

import Evergreen.V39.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V39.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V39.Api.YoutubeModel.Channel)
    | GetChannels
