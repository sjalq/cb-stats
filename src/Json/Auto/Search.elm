module Json.Auto.Search exposing (..)

import Json.Decode



-- Required packages:
-- * elm/json


type alias Root =
    { etag : String
    , items : List RootItemsObject
    , kind : String
    , pageInfo : RootPageInfo
    , regionCode : String
    }


type alias RootItemsObject =
    { etag : String
    , id : RootItemsObjectId
    , kind : String
    , snippet : RootItemsObjectSnippet
    }


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


type alias RootPageInfo =
    { resultsPerPage : Int
    , totalResults : Int
    }


rootDecoder : Json.Decode.Decoder Root
rootDecoder =
    Json.Decode.map5 Root
        (Json.Decode.field "etag" Json.Decode.string)
        (Json.Decode.field "items" <| Json.Decode.list rootItemsObjectDecoder)
        (Json.Decode.field "kind" Json.Decode.string)
        (Json.Decode.field "pageInfo" rootPageInfoDecoder)
        (Json.Decode.field "regionCode" Json.Decode.string)


rootItemsObjectDecoder : Json.Decode.Decoder RootItemsObject
rootItemsObjectDecoder =
    Json.Decode.map4 RootItemsObject
        (Json.Decode.field "etag" Json.Decode.string)
        (Json.Decode.field "id" rootItemsObjectIdDecoder)
        (Json.Decode.field "kind" Json.Decode.string)
        (Json.Decode.field "snippet" rootItemsObjectSnippetDecoder)


rootItemsObjectIdDecoder : Json.Decode.Decoder RootItemsObjectId
rootItemsObjectIdDecoder =
    Json.Decode.map2 RootItemsObjectId
        (Json.Decode.field "kind" Json.Decode.string)
        (Json.Decode.field "videoId" Json.Decode.string)


rootItemsObjectSnippetDecoder : Json.Decode.Decoder RootItemsObjectSnippet
rootItemsObjectSnippetDecoder =
    Json.Decode.map7 RootItemsObjectSnippet
        (Json.Decode.field "channelId" Json.Decode.string)
        (Json.Decode.field "channelTitle" Json.Decode.string)
        (Json.Decode.field "description" Json.Decode.string)
        (Json.Decode.field "liveBroadcastContent" Json.Decode.string)
        (Json.Decode.field "publishTime" Json.Decode.string)
        (Json.Decode.field "publishedAt" Json.Decode.string)
        (Json.Decode.field "title" Json.Decode.string)


rootPageInfoDecoder : Json.Decode.Decoder RootPageInfo
rootPageInfoDecoder =
    Json.Decode.map2 RootPageInfo
        (Json.Decode.field "resultsPerPage" Json.Decode.int)
        (Json.Decode.field "totalResults" Json.Decode.int)
