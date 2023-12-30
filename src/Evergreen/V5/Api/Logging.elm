module Evergreen.V5.Api.Logging exposing (..)

import Time


type LogLevel
    = Error
    | Info
    | Alert


type alias LogEntry =
    { message : String
    , timeStamp : Time.Posix
    , logLevel : LogLevel
    }
