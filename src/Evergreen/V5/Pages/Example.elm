module Evergreen.V5.Pages.Example exposing (..)

import Evergreen.V5.Api.YoutubeModel
import Time


type alias Model =
    { clientCredentials : List Evergreen.V5.Api.YoutubeModel.ClientCredentials
    , currentTime : Time.Posix
    }


type Msg
    = GotCredentials (List Evergreen.V5.Api.YoutubeModel.ClientCredentials)
    | GetChannels String
    | Tick Time.Posix
