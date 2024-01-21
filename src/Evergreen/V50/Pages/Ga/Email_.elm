module Evergreen.V50.Pages.Ga.Email_ exposing (..)

import Evergreen.V50.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V50.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V50.Api.YoutubeModel.Channel)
    | GetChannels
