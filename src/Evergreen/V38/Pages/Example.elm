module Evergreen.V38.Pages.Example exposing (..)

import Dict
import Evergreen.V38.Api.YoutubeModel
import Time


type alias Model =
    { clientCredentials : Dict.Dict String Evergreen.V38.Api.YoutubeModel.ClientCredentials
    , currentTime : Time.Posix
    , noAccessKeysIncluded : Bool
    }


type Msg
    = GotCredentials (Dict.Dict String Evergreen.V38.Api.YoutubeModel.ClientCredentials)
    | GetChannels String
    | Yeet String
    | Tick Time.Posix
