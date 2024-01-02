module Evergreen.V8.Pages.Log exposing (..)

import Evergreen.V8.Api.Logging


type alias Model =
    { logs : List Evergreen.V8.Api.Logging.LogEntry
    }


type Msg
    = GotLogs (List Evergreen.V8.Api.Logging.LogEntry)
