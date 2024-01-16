module Evergreen.V35.Pages.Ga.Email_ exposing (..)

import Evergreen.V35.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V35.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V35.Api.YoutubeModel.Channel)
    | GetChannels
