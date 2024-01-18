module Evergreen.V40.Pages.Ga.Email_ exposing (..)

import Evergreen.V40.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V40.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V40.Api.YoutubeModel.Channel)
    | GetChannels
