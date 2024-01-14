module Evergreen.V22.Pages.Ga.Email_ exposing (..)

import Evergreen.V22.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V22.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V22.Api.YoutubeModel.Channel)
    | GetChannels
