module Evergreen.V78.Api.Logging exposing (..)

import Time


type LogLevel
    = Error
    | Info
    | Alert


type alias LogEntry =
    { message : String
    , timestamp : Time.Posix
    , logLevel : LogLevel
    }
