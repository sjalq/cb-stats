module Evergreen.V26.Pages.Ga.Email_ exposing (..)

import Evergreen.V26.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V26.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V26.Api.YoutubeModel.Channel)
    | GetChannels
