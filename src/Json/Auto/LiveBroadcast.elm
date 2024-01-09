module Json.Auto.LiveBroadcast exposing (..)

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
    { actualStartTime : String
    , channelId : String
    , description : String
    , isDefaultBroadcast : Bool
    , liveChatId : String
    , publishedAt : String
    , scheduledStartTime : String
    , thumbnails : RootItemsObjectSnippetThumbnails
    , title : String
    }


type alias RootItemsObjectSnippetThumbnails =
    { standard : RootItemsObjectSnippetThumbnailsStandard
    }


type alias RootItemsObjectSnippetThumbnailsStandard =
    { height : Int
    , url : String
    , width : Int
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
    let
        fieldSet0 = 
            Json.Decode.map8 RootItemsObjectSnippet
                (Json.Decode.field "actualStartTime" Json.Decode.string)
                (Json.Decode.field "channelId" Json.Decode.string)
                (Json.Decode.field "description" Json.Decode.string)
                (Json.Decode.field "isDefaultBroadcast" Json.Decode.bool)
                (Json.Decode.field "liveChatId" Json.Decode.string)
                (Json.Decode.field "publishedAt" Json.Decode.string)
                (Json.Decode.field "scheduledStartTime" Json.Decode.string)
                (Json.Decode.field "thumbnails" rootItemsObjectSnippetThumbnailsDecoder)
    in
    Json.Decode.map2 (<|)
        fieldSet0
        (Json.Decode.field "title" Json.Decode.string)


rootItemsObjectSnippetThumbnailsDecoder : Json.Decode.Decoder RootItemsObjectSnippetThumbnails
rootItemsObjectSnippetThumbnailsDecoder = 
    Json.Decode.map RootItemsObjectSnippetThumbnails
        (Json.Decode.field "standard" rootItemsObjectSnippetThumbnailsStandardDecoder)


rootItemsObjectSnippetThumbnailsStandardDecoder : Json.Decode.Decoder RootItemsObjectSnippetThumbnailsStandard
rootItemsObjectSnippetThumbnailsStandardDecoder = 
    Json.Decode.map3 RootItemsObjectSnippetThumbnailsStandard
        (Json.Decode.field "height" Json.Decode.int)
        (Json.Decode.field "url" Json.Decode.string)
        (Json.Decode.field "width" Json.Decode.int)


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
        [ ( "actualStartTime", Json.Encode.string rootItemsObjectSnippet.actualStartTime )
        , ( "channelId", Json.Encode.string rootItemsObjectSnippet.channelId )
        , ( "description", Json.Encode.string rootItemsObjectSnippet.description )
        , ( "isDefaultBroadcast", Json.Encode.bool rootItemsObjectSnippet.isDefaultBroadcast )
        , ( "liveChatId", Json.Encode.string rootItemsObjectSnippet.liveChatId )
        , ( "publishedAt", Json.Encode.string rootItemsObjectSnippet.publishedAt )
        , ( "scheduledStartTime", Json.Encode.string rootItemsObjectSnippet.scheduledStartTime )
        , ( "thumbnails", encodedRootItemsObjectSnippetThumbnails rootItemsObjectSnippet.thumbnails )
        , ( "title", Json.Encode.string rootItemsObjectSnippet.title )
        ]


encodedRootItemsObjectSnippetThumbnails : RootItemsObjectSnippetThumbnails -> Json.Encode.Value
encodedRootItemsObjectSnippetThumbnails rootItemsObjectSnippetThumbnails = 
    Json.Encode.object
        [ ( "standard", encodedRootItemsObjectSnippetThumbnailsStandard rootItemsObjectSnippetThumbnails.standard )
        ]


encodedRootItemsObjectSnippetThumbnailsStandard : RootItemsObjectSnippetThumbnailsStandard -> Json.Encode.Value
encodedRootItemsObjectSnippetThumbnailsStandard rootItemsObjectSnippetThumbnailsStandard = 
    Json.Encode.object
        [ ( "height", Json.Encode.int rootItemsObjectSnippetThumbnailsStandard.height )
        , ( "url", Json.Encode.string rootItemsObjectSnippetThumbnailsStandard.url )
        , ( "width", Json.Encode.int rootItemsObjectSnippetThumbnailsStandard.width )
        ]


encodedRootPageInfo : RootPageInfo -> Json.Encode.Value
encodedRootPageInfo rootPageInfo = 
    Json.Encode.object
        [ ( "resultsPerPage", Json.Encode.int rootPageInfo.resultsPerPage )
        , ( "totalResults", Json.Encode.int rootPageInfo.totalResults )
        ]