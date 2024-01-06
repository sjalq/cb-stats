module Evergreen.V16.Pages.Log exposing (..)

import Evergreen.V16.Api.Logging


type alias Model =
    { logs : List Evergreen.V16.Api.Logging.LogEntry
    }


type Msg
    = GotLogs (List Evergreen.V16.Api.Logging.LogEntry)
