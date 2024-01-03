module Evergreen.V12.Pages.Log exposing (..)

import Evergreen.V12.Api.Logging


type alias Model =
    { logs : List Evergreen.V12.Api.Logging.LogEntry
    }


type Msg
    = GotLogs (List Evergreen.V12.Api.Logging.LogEntry)
