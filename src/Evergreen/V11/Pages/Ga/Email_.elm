module Evergreen.V11.Pages.Ga.Email_ exposing (..)

import Evergreen.V11.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V11.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V11.Api.YoutubeModel.Channel)
    | GetChannels
