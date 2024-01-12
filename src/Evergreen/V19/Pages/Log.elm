module Evergreen.V19.Pages.Log exposing (..)

import Evergreen.V19.Api.Logging


type alias Model =
    { logs : List Evergreen.V19.Api.Logging.LogEntry
    }


type Msg
    = GotLogs (List Evergreen.V19.Api.Logging.LogEntry)
