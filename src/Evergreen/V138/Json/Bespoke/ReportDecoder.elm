module Evergreen.V138.Json.Bespoke.ReportDecoder exposing (..)


type alias YouTubeAnalyticsRecord =
    { day : String
    , averageViewPercentage : Float
    , subscribersGained : Int
    , subscribersLost : Int
    , views : Int
    }
