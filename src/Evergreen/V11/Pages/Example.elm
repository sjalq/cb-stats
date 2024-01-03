module Evergreen.V11.Pages.Example exposing (..)

import Evergreen.V11.Api.YoutubeModel
import Time


type alias Model =
    { clientCredentials : List Evergreen.V11.Api.YoutubeModel.ClientCredentials
    , currentTime : Time.Posix
    }


type Msg
    = GotCredentials (List Evergreen.V11.Api.YoutubeModel.ClientCredentials)
    | GetChannels String
    | Tick Time.Posix
