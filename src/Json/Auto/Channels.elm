module Json.Auto.Channels exposing (..)

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
    { customUrl : String
    , description : String
    , localized : RootItemsObjectSnippetLocalized
    , publishedAt : String
    , thumbnails : RootItemsObjectSnippetThumbnails
    , title : String
    }


type alias RootItemsObjectSnippetLocalized =
    { description : String
    , title : String
    }


type alias RootItemsObjectSnippetThumbnails =
    { default : RootItemsObjectSnippetThumbnailsDefault
    , high : RootItemsObjectSnippetThumbnailsHigh
    , medium : RootItemsObjectSnippetThumbnailsMedium
    }


type alias RootItemsObjectSnippetThumbnailsDefault =
    { height : Int
    , url : String
    , width : Int
    }


type alias RootItemsObjectSnippetThumbnailsHigh =
    { height : Int
    , url : String
    , width : Int
    }


type alias RootItemsObjectSnippetThumbnailsMedium =
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
    Json.Decode.map6 RootItemsObjectSnippet
        (Json.Decode.field "customUrl" Json.Decode.string)
        (Json.Decode.field "description" Json.Decode.string)
        (Json.Decode.field "localized" rootItemsObjectSnippetLocalizedDecoder)
        (Json.Decode.field "publishedAt" Json.Decode.string)
        (Json.Decode.field "thumbnails" rootItemsObjectSnippetThumbnailsDecoder)
        (Json.Decode.field "title" Json.Decode.string)


rootItemsObjectSnippetLocalizedDecoder : Json.Decode.Decoder RootItemsObjectSnippetLocalized
rootItemsObjectSnippetLocalizedDecoder = 
    Json.Decode.map2 RootItemsObjectSnippetLocalized
        (Json.Decode.field "description" Json.Decode.string)
        (Json.Decode.field "title" Json.Decode.string)


rootItemsObjectSnippetThumbnailsDecoder : Json.Decode.Decoder RootItemsObjectSnippetThumbnails
rootItemsObjectSnippetThumbnailsDecoder = 
    Json.Decode.map3 RootItemsObjectSnippetThumbnails
        (Json.Decode.field "default" rootItemsObjectSnippetThumbnailsDefaultDecoder)
        (Json.Decode.field "high" rootItemsObjectSnippetThumbnailsHighDecoder)
        (Json.Decode.field "medium" rootItemsObjectSnippetThumbnailsMediumDecoder)


rootItemsObjectSnippetThumbnailsDefaultDecoder : Json.Decode.Decoder RootItemsObjectSnippetThumbnailsDefault
rootItemsObjectSnippetThumbnailsDefaultDecoder = 
    Json.Decode.map3 RootItemsObjectSnippetThumbnailsDefault
        (Json.Decode.field "height" Json.Decode.int)
        (Json.Decode.field "url" Json.Decode.string)
        (Json.Decode.field "width" Json.Decode.int)


rootItemsObjectSnippetThumbnailsHighDecoder : Json.Decode.Decoder RootItemsObjectSnippetThumbnailsHigh
rootItemsObjectSnippetThumbnailsHighDecoder = 
    Json.Decode.map3 RootItemsObjectSnippetThumbnailsHigh
        (Json.Decode.field "height" Json.Decode.int)
        (Json.Decode.field "url" Json.Decode.string)
        (Json.Decode.field "width" Json.Decode.int)


rootItemsObjectSnippetThumbnailsMediumDecoder : Json.Decode.Decoder RootItemsObjectSnippetThumbnailsMedium
rootItemsObjectSnippetThumbnailsMediumDecoder = 
    Json.Decode.map3 RootItemsObjectSnippetThumbnailsMedium
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
        [ ( "customUrl", Json.Encode.string rootItemsObjectSnippet.customUrl )
        , ( "description", Json.Encode.string rootItemsObjectSnippet.description )
        , ( "localized", encodedRootItemsObjectSnippetLocalized rootItemsObjectSnippet.localized )
        , ( "publishedAt", Json.Encode.string rootItemsObjectSnippet.publishedAt )
        , ( "thumbnails", encodedRootItemsObjectSnippetThumbnails rootItemsObjectSnippet.thumbnails )
        , ( "title", Json.Encode.string rootItemsObjectSnippet.title )
        ]


encodedRootItemsObjectSnippetLocalized : RootItemsObjectSnippetLocalized -> Json.Encode.Value
encodedRootItemsObjectSnippetLocalized rootItemsObjectSnippetLocalized = 
    Json.Encode.object
        [ ( "description", Json.Encode.string rootItemsObjectSnippetLocalized.description )
        , ( "title", Json.Encode.string rootItemsObjectSnippetLocalized.title )
        ]


encodedRootItemsObjectSnippetThumbnails : RootItemsObjectSnippetThumbnails -> Json.Encode.Value
encodedRootItemsObjectSnippetThumbnails rootItemsObjectSnippetThumbnails = 
    Json.Encode.object
        [ ( "default", encodedRootItemsObjectSnippetThumbnailsDefault rootItemsObjectSnippetThumbnails.default )
        , ( "high", encodedRootItemsObjectSnippetThumbnailsHigh rootItemsObjectSnippetThumbnails.high )
        , ( "medium", encodedRootItemsObjectSnippetThumbnailsMedium rootItemsObjectSnippetThumbnails.medium )
        ]


encodedRootItemsObjectSnippetThumbnailsDefault : RootItemsObjectSnippetThumbnailsDefault -> Json.Encode.Value
encodedRootItemsObjectSnippetThumbnailsDefault rootItemsObjectSnippetThumbnailsDefault = 
    Json.Encode.object
        [ ( "height", Json.Encode.int rootItemsObjectSnippetThumbnailsDefault.height )
        , ( "url", Json.Encode.string rootItemsObjectSnippetThumbnailsDefault.url )
        , ( "width", Json.Encode.int rootItemsObjectSnippetThumbnailsDefault.width )
        ]


encodedRootItemsObjectSnippetThumbnailsHigh : RootItemsObjectSnippetThumbnailsHigh -> Json.Encode.Value
encodedRootItemsObjectSnippetThumbnailsHigh rootItemsObjectSnippetThumbnailsHigh = 
    Json.Encode.object
        [ ( "height", Json.Encode.int rootItemsObjectSnippetThumbnailsHigh.height )
        , ( "url", Json.Encode.string rootItemsObjectSnippetThumbnailsHigh.url )
        , ( "width", Json.Encode.int rootItemsObjectSnippetThumbnailsHigh.width )
        ]


encodedRootItemsObjectSnippetThumbnailsMedium : RootItemsObjectSnippetThumbnailsMedium -> Json.Encode.Value
encodedRootItemsObjectSnippetThumbnailsMedium rootItemsObjectSnippetThumbnailsMedium = 
    Json.Encode.object
        [ ( "height", Json.Encode.int rootItemsObjectSnippetThumbnailsMedium.height )
        , ( "url", Json.Encode.string rootItemsObjectSnippetThumbnailsMedium.url )
        , ( "width", Json.Encode.int rootItemsObjectSnippetThumbnailsMedium.width )
        ]


encodedRootPageInfo : RootPageInfo -> Json.Encode.Value
encodedRootPageInfo rootPageInfo = 
    Json.Encode.object
        [ ( "resultsPerPage", Json.Encode.int rootPageInfo.resultsPerPage )
        , ( "totalResults", Json.Encode.int rootPageInfo.totalResults )
        ]