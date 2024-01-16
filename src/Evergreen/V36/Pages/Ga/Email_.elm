module Evergreen.V36.Pages.Ga.Email_ exposing (..)

import Evergreen.V36.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V36.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V36.Api.YoutubeModel.Channel)
    | GetChannels
