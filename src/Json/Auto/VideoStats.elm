module Json.Auto.VideoStats exposing (..)
 
import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (optional, required)




-- Required packages:
-- * elm/json


type alias Root =
    { etag : String
    , items : List RootItemsObject
    , kind : String
    , pageInfo : RootPageInfo
    }


type alias RootItemsObject =
    { etag : String
    , id : String
    , kind : String
    , statistics : RootItemsObjectStatistics
    }


type alias RootItemsObjectStatistics =
    { commentCount : Maybe String
    , dislikeCount : Maybe String
    , favoriteCount : Maybe String
    , likeCount : String
    , viewCount : String
    }


type alias RootPageInfo =
    { resultsPerPage : Int
    , totalResults : Int
    }


rootDecoder : Json.Decode.Decoder Root
rootDecoder =
    Json.Decode.map4 Root
        (Json.Decode.field "etag" Json.Decode.string)
        (Json.Decode.field "items" <| Json.Decode.list rootItemsObjectDecoder)
        (Json.Decode.field "kind" Json.Decode.string)
        (Json.Decode.field "pageInfo" rootPageInfoDecoder)


rootItemsObjectDecoder : Json.Decode.Decoder RootItemsObject
rootItemsObjectDecoder =
    Json.Decode.map4 RootItemsObject
        (Json.Decode.field "etag" Json.Decode.string)
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "kind" Json.Decode.string)
        (Json.Decode.field "statistics" rootItemsObjectStatisticsDecoder)


rootItemsObjectStatisticsDecoder : Json.Decode.Decoder RootItemsObjectStatistics
rootItemsObjectStatisticsDecoder =
    Json.Decode.succeed RootItemsObjectStatistics
        |> optional "commentCount" (maybe string) Nothing
        |> optional "dislikeCount" (maybe string) Nothing
        |> optional "favoriteCount" (maybe string) Nothing
        |> required "likeCount" Json.Decode.string
        |> required "viewCount" Json.Decode.string


rootPageInfoDecoder : Json.Decode.Decoder RootPageInfo
rootPageInfoDecoder =
    Json.Decode.map2 RootPageInfo
        (Json.Decode.field "resultsPerPage" Json.Decode.int)
        (Json.Decode.field "totalResults" Json.Decode.int)

