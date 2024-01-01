module Evergreen.V6.Pages.Example exposing (..)

import Evergreen.V6.Api.YoutubeModel
import Time


type alias Model =
    { clientCredentials : List Evergreen.V6.Api.YoutubeModel.ClientCredentials
    , currentTime : Time.Posix
    }


type Msg
    = GotCredentials (List Evergreen.V6.Api.YoutubeModel.ClientCredentials)
    | GetChannels String
    | Tick Time.Posix
