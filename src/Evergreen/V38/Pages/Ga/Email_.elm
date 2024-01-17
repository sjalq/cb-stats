module Evergreen.V38.Pages.Ga.Email_ exposing (..)

import Evergreen.V38.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V38.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V38.Api.YoutubeModel.Channel)
    | GetChannels
