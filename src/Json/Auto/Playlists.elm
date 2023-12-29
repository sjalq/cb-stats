module Json.Auto.Playlists exposing (..)

import Json.Decode
import Json.Encode


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
    , snippet : RootItemsObjectSnippet
    }


type alias RootItemsObjectSnippet =
    { channelId : String
    , description : String
    , publishedAt : String
    , title : String
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
        (Json.Decode.field "snippet" rootItemsObjectSnippetDecoder)


rootItemsObjectSnippetDecoder : Json.Decode.Decoder RootItemsObjectSnippet
rootItemsObjectSnippetDecoder = 
    Json.Decode.map4 RootItemsObjectSnippet
        (Json.Decode.field "channelId" Json.Decode.string)
        (Json.Decode.field "description" Json.Decode.string)
        (Json.Decode.field "publishedAt" Json.Decode.string)
        (Json.Decode.field "title" Json.Decode.string)


rootPageInfoDecoder : Json.Decode.Decoder RootPageInfo
rootPageInfoDecoder = 
    Json.Decode.map2 RootPageInfo
        (Json.Decode.field "resultsPerPage" Json.Decode.int)
        (Json.Decode.field "totalResults" Json.Decode.int)


encodedRoot : Root -> Json.Encode.Value
encodedRoot root = 
    Json.Encode.object
        [ ( "etag", Json.Encode.string root.etag )
        , ( "items", Json.Encode.list encodedRootItemsObject root.items )
        , ( "kind", Json.Encode.string root.kind )
        , ( "pageInfo", encodedRootPageInfo root.pageInfo )
        ]


encodedRootItemsObject : RootItemsObject -> Json.Encode.Value
encodedRootItemsObject rootItemsObject = 
    Json.Encode.object
        [ ( "etag", Json.Encode.string rootItemsObject.etag )
        , ( "id", Json.Encode.string rootItemsObject.id )
        , ( "kind", Json.Encode.string rootItemsObject.kind )
        , ( "snippet", encodedRootItemsObjectSnippet rootItemsObject.snippet )
        ]


encodedRootItemsObjectSnippet : RootItemsObjectSnippet -> Json.Encode.Value
encodedRootItemsObjectSnippet rootItemsObjectSnippet = 
    Json.Encode.object
        [ ( "channelId", Json.Encode.string rootItemsObjectSnippet.channelId )
        , ( "description", Json.Encode.string rootItemsObjectSnippet.description )
        , ( "publishedAt", Json.Encode.string rootItemsObjectSnippet.publishedAt )
        , ( "title", Json.Encode.string rootItemsObjectSnippet.title )
        ]


encodedRootPageInfo : RootPageInfo -> Json.Encode.Value
encodedRootPageInfo rootPageInfo = 
    Json.Encode.object
        [ ( "resultsPerPage", Json.Encode.int rootPageInfo.resultsPerPage )
        , ( "totalResults", Json.Encode.int rootPageInfo.totalResults )
        ]