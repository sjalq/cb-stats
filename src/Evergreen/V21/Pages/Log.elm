module Evergreen.V21.Pages.Log exposing (..)

import Evergreen.V21.Api.Logging


type alias Model =
    { logs : List Evergreen.V21.Api.Logging.LogEntry
    , logIndex : Int
    }


type Msg
    = GotLogs Int (List Evergreen.V21.Api.Logging.LogEntry)
    | GetLogPage Int Int
    | YeetLogs
