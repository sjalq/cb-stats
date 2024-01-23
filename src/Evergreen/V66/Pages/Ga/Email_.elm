module Evergreen.V66.Pages.Ga.Email_ exposing (..)

import Evergreen.V66.Api.YoutubeModel


type alias Model =
    { email : String
    , channels : List Evergreen.V66.Api.YoutubeModel.Channel
    }


type Msg
    = GotChannels (List Evergreen.V66.Api.YoutubeModel.Channel)
    | GetChannels
