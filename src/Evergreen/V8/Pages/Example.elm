module Evergreen.V8.Pages.Example exposing (..)

import Evergreen.V8.Api.YoutubeModel
import Time


type alias Model =
    { clientCredentials : List Evergreen.V8.Api.YoutubeModel.ClientCredentials
    , currentTime : Time.Posix
    }


type Msg
    = GotCredentials (List Evergreen.V8.Api.YoutubeModel.ClientCredentials)
    | GetChannels String
    | Tick Time.Posix
