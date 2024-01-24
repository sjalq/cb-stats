module Evergreen.V78.Pages.Ga.Email_ exposing (..)

import Evergreen.V78.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V78.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V78.Api.YoutubeModel.Channel)
    | GetChannels
