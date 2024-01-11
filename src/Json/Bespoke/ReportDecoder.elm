module Json.Bespoke.ReportDecoder exposing (..)

import Json.Decode exposing (Decoder, field, float, index, int, map4, string)


type alias YouTubeAnalyticsRecord =
    { day : String
    , averageViewPercentage : Float
    , subscribersGained : Int
    , subscribersLost : Int
    }


youtubeAnalyticsRecordDecoder : Decoder YouTubeAnalyticsRecord
youtubeAnalyticsRecordDecoder =
    index 0
        (-- Access the first row
         map4 YouTubeAnalyticsRecord
            (index 0 string)
            -- Day
            (index 1 float)
            -- Average View Percentage
            (index 2 int)
            -- Subscribers Gained
            (index 3 int)
         -- Subscribers Lost
        )



-- Wrapper to decode the whole object


youtubeAnalyticsDecoder : Decoder YouTubeAnalyticsRecord
youtubeAnalyticsDecoder =
    field "rows" youtubeAnalyticsRecordDecoder
