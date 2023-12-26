module Api.Logging exposing (..)

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


logToList : String -> Time.Posix -> LogLevel -> List LogEntry -> List LogEntry
logToList logMessage timeStamp level logs =
    let
        newLogEntry =
            { message = logMessage
            , timeStamp = timeStamp
            , logLevel = level
            }
    in
    logs ++ [ newLogEntry ]


logToModel : String -> Time.Posix -> LogLevel -> { a | logs : List LogEntry } -> { a | logs : List LogEntry }
logToModel logMessage timeStamp level model =
    { model | logs = logToList logMessage timeStamp level model.logs }


posixToString : Time.Posix -> String
posixToString timeStamp =
    String.fromInt (Time.toYear Time.utc timeStamp)
        ++ "/"
        ++ monthToString (Time.toMonth Time.utc timeStamp)
        ++ "/"
        ++ String.fromInt (Time.toDay Time.utc timeStamp)
        ++ " "
        ++ String.fromInt (Time.toHour Time.utc timeStamp)
        ++ ":"
        ++ String.fromInt (Time.toMinute Time.utc timeStamp)
        ++ ":"
        ++ String.fromInt (Time.toSecond Time.utc timeStamp)
        ++ " - "


monthToString : Time.Month -> String
monthToString month =
    case month of
        Time.Jan ->
            "01"

        Time.Feb ->
            "02"

        Time.Mar ->
            "03"

        Time.Apr ->
            "04"

        Time.May ->
            "05"

        Time.Jun ->
            "06"

        Time.Jul ->
            "07"

        Time.Aug ->
            "08"

        Time.Sep ->
            "09"

        Time.Oct ->
            "10"

        Time.Nov ->
            "11"

        Time.Dec ->
            "12"
