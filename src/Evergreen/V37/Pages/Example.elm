module Evergreen.V37.Pages.Example exposing (..)

import Dict
import Evergreen.V37.Api.YoutubeModel
import Time


type alias Model =
    { clientCredentials : Dict.Dict String Evergreen.V37.Api.YoutubeModel.ClientCredentials
    , currentTime : Time.Posix
    , noAccessKeysIncluded : Bool
    }


type Msg
    = GotCredentials (Dict.Dict String Evergreen.V37.Api.YoutubeModel.ClientCredentials)
    | GetChannels String
    | Tick Time.Posix
