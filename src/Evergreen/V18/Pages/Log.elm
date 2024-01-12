module Evergreen.V18.Pages.Log exposing (..)

import Evergreen.V18.Api.Logging


type alias Model =
    { logs : List Evergreen.V18.Api.Logging.LogEntry
    }


type Msg
    = GotLogs (List Evergreen.V18.Api.Logging.LogEntry)
