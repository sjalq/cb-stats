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


seconds =
    second


minute =
    60 * second


minutes =
    minute


hour =
    60 * minute


hours =
    hour


day =
    24 * hour


days =
    day


strToIntTime =
    Iso8601.toTime >> Result.map Time.posixToMillis >> Result.withDefault 0


intTimeToStr =
    Time.millisToPosix >> Iso8601.fromTime


timeToStr =
    Iso8601.fromTime
