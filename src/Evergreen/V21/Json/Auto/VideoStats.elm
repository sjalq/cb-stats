module Evergreen.V21.Json.Auto.VideoStats exposing (..)


type alias RootItemsObjectStatistics =
    { commentCount : Maybe String
    , dislikeCount : Maybe String
    , favoriteCount : Maybe String
    , likeCount : String
    , viewCount : String
    }


type alias RootItemsObject =
    { etag : String
    , id : String
    , kind : String
    , statistics : RootItemsObjectStatistics
    }


type alias RootPageInfo =
    { resultsPerPage : Int
    , totalResults : Int
    }


type alias Root =
    { etag : String
    , items : List RootItemsObject
    , kind : String
    , pageInfo : RootPageInfo
    }
