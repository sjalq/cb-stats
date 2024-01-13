module Evergreen.V20.Pages.Ga.Email_ exposing (..)

import Evergreen.V20.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V20.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V20.Api.YoutubeModel.Channel)
    | GetChannels
