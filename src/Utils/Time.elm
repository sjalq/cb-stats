module Utils.Time exposing (..)

import DateFormat as DF
import Iso8601
import Time


formatDate : Time.Posix -> String
formatDate =
    DF.format
        [ DF.monthNameFull
        , DF.text " "
        , DF.dayOfMonthNumber
        , DF.text ", "
        , DF.yearNumber
        ]
        Time.utc


second =
    1000


minute =
    60 * second


hour =
    60 * minute


day =
    24 * hour


strToIntTime =
    Iso8601.toTime >> Result.map Time.posixToMillis >> Result.withDefault 0


intTimeToStr =
    Time.millisToPosix >> Iso8601.fromTime

timeToStr =
    Iso8601.fromTime