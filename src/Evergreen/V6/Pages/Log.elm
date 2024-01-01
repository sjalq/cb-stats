module Evergreen.V6.Pages.Log exposing (..)

import Evergreen.V6.Api.Logging


type alias Model =
    { logs : List Evergreen.V6.Api.Logging.LogEntry
    }


type Msg
    = GotLogs (List Evergreen.V6.Api.Logging.LogEntry)
