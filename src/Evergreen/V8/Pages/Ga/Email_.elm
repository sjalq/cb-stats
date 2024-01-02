module Evergreen.V8.Pages.Ga.Email_ exposing (..)

import Evergreen.V8.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V8.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V8.Api.YoutubeModel.Channel)
    | GetChannels
