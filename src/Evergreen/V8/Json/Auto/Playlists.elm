module Evergreen.V8.Json.Auto.Playlists exposing (..)


type alias RootItemsObjectSnippet =
    { channelId : String
    , description : String
    , publishedAt : String
    , title : String
    }


type alias RootItemsObject =
    { etag : String
    , id : String
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
    }
