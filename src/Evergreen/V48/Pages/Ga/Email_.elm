module Evergreen.V48.Pages.Ga.Email_ exposing (..)

import Evergreen.V48.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V48.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V48.Api.YoutubeModel.Channel)
    | GetChannels
