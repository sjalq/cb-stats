module Evergreen.V20.Pages.Log exposing (..)

import Evergreen.V20.Api.Logging


type alias Model =
    { logs : List Evergreen.V20.Api.Logging.LogEntry
    }


type Msg
    = GotLogs (List Evergreen.V20.Api.Logging.LogEntry)
