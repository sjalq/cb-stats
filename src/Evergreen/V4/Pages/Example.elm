module Evergreen.V4.Pages.Example exposing (..)

import Evergreen.V4.Api.ClientCredentials
import Time


type alias Model =
    { clientCredentials : List Evergreen.V4.Api.ClientCredentials.ClientCredentials
    , currentTime : Time.Posix
    }


type Msg
    = GotCredentials (List Evergreen.V4.Api.ClientCredentials.ClientCredentials)
    | GetChannels String
    | Tick Time.Posix
