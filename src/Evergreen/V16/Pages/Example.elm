module Evergreen.V16.Pages.Example exposing (..)

import Dict
import Evergreen.V16.Api.YoutubeModel
import Time


type alias Model =
    { clientCredentials : Dict.Dict String Evergreen.V16.Api.YoutubeModel.ClientCredentials
    , currentTime : Time.Posix
    , noAccessKeysIncluded : Bool
    }


type Msg
    = GotCredentials (Dict.Dict String Evergreen.V16.Api.YoutubeModel.ClientCredentials)
    | GetChannels String
    | Tick Time.Posix
