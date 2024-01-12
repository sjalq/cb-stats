module Evergreen.V18.Pages.Example exposing (..)

import Dict
import Evergreen.V18.Api.YoutubeModel
import Time


type alias Model =
    { clientCredentials : Dict.Dict String Evergreen.V18.Api.YoutubeModel.ClientCredentials
    , currentTime : Time.Posix
    , noAccessKeysIncluded : Bool
    }


type Msg
    = GotCredentials (Dict.Dict String Evergreen.V18.Api.YoutubeModel.ClientCredentials)
    | GetChannels String
    | Tick Time.Posix
