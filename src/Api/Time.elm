module Api.Time exposing (..)

import Time
import Iso8601

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