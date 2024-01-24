module Evergreen.V77.Json.Auto.Search exposing (..)


type alias RootItemsObjectId =
    { kind : String
    , videoId : String
    }


type alias RootItemsObjectSnippet =
    { channelId : String
    , channelTitle : String
    , description : String
    , liveBroadcastContent : String
    , publishTime : String
    , publishedAt : String
    , title : String
    }


type alias RootItemsObject =
    { etag : String
    , id : RootItemsObjectId
    , kind : String
    , snippet : RootItemsObjectSnippet
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
    , regionCode : String
    }
