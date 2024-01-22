module Evergreen.V54.Pages.Ga.Email_ exposing (..)

import Evergreen.V54.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V54.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V54.Api.YoutubeModel.Channel)
    | GetChannels
