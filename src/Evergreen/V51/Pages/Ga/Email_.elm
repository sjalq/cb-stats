module Evergreen.V51.Pages.Ga.Email_ exposing (..)

import Evergreen.V51.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V51.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V51.Api.YoutubeModel.Channel)
    | GetChannels
