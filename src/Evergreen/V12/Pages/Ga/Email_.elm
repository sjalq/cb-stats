module Evergreen.V12.Pages.Ga.Email_ exposing (..)

import Evergreen.V12.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V12.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V12.Api.YoutubeModel.Channel)
    | GetChannels
