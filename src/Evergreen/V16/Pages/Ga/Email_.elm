module Evergreen.V16.Pages.Ga.Email_ exposing (..)

import Evergreen.V16.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V16.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V16.Api.YoutubeModel.Channel)
    | GetChannels
