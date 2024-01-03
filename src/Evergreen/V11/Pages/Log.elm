module Evergreen.V11.Pages.Log exposing (..)

import Evergreen.V11.Api.Logging


type alias Model =
    { logs : List Evergreen.V11.Api.Logging.LogEntry
    }


type Msg
    = GotLogs (List Evergreen.V11.Api.Logging.LogEntry)
