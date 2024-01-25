module Evergreen.V94.Pages.Ga.Email_ exposing (..)

import Evergreen.V94.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V94.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V94.Api.YoutubeModel.Channel)
    | GetChannels
