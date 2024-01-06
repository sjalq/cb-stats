module Json.Auto.PlaylistItems exposing (..)

import Json.Decode
import Json.Encode



-- Required packages:
-- * elm/json


type alias Root =
    { etag : String
    , items : List RootItemsObject
    , kind : String
    , nextPageToken : Maybe String
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
    , channelTitle : String
    , description : String
    , playlistId : String
    , position : Int
    , publishedAt : String
    , resourceId : RootItemsObjectSnippetResourceId
    , thumbnails : RootItemsObjectSnippetThumbnails
    , title : String
    , videoOwnerChannelId : String
    , videoOwnerChannelTitle : String
    }


type alias RootItemsObjectSnippetResourceId =
    { kind : String
    , videoId : String
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
    Json.Decode.map5 Root
        (Json.Decode.field "etag" Json.Decode.string)
        (Json.Decode.field "items" <| Json.Decode.list rootItemsObjectDecoder)
        (Json.Decode.field "kind" Json.Decode.string)
        (Json.Decode.maybe <| Json.Decode.field "nextPageToken" Json.Decode.string)
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
                (Json.Decode.field "channelId" Json.Decode.string)
                (Json.Decode.field "channelTitle" Json.Decode.string)
                (Json.Decode.field "description" Json.Decode.string)
                (Json.Decode.field "playlistId" Json.Decode.string)
                (Json.Decode.field "position" Json.Decode.int)
                (Json.Decode.field "publishedAt" Json.Decode.string)
                (Json.Decode.field "resourceId" rootItemsObjectSnippetResourceIdDecoder)
                (Json.Decode.field "thumbnails" rootItemsObjectSnippetThumbnailsDecoder)
    in
    Json.Decode.map4 (<|)
        fieldSet0
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "videoOwnerChannelId" Json.Decode.string)
        (Json.Decode.field "videoOwnerChannelTitle" Json.Decode.string)


rootItemsObjectSnippetResourceIdDecoder : Json.Decode.Decoder RootItemsObjectSnippetResourceId
rootItemsObjectSnippetResourceIdDecoder =
    Json.Decode.map2 RootItemsObjectSnippetResourceId
        (Json.Decode.field "kind" Json.Decode.string)
        (Json.Decode.field "videoId" Json.Decode.string)


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
        [ ( "channelId", Json.Encode.string rootItemsObjectSnippet.channelId )
        , ( "channelTitle", Json.Encode.string rootItemsObjectSnippet.channelTitle )
        , ( "description", Json.Encode.string rootItemsObjectSnippet.description )
        , ( "playlistId", Json.Encode.string rootItemsObjectSnippet.playlistId )
        , ( "position", Json.Encode.int rootItemsObjectSnippet.position )
        , ( "publishedAt", Json.Encode.string rootItemsObjectSnippet.publishedAt )
        , ( "resourceId", encodedRootItemsObjectSnippetResourceId rootItemsObjectSnippet.resourceId )
        , ( "thumbnails", encodedRootItemsObjectSnippetThumbnails rootItemsObjectSnippet.thumbnails )
        , ( "title", Json.Encode.string rootItemsObjectSnippet.title )
        , ( "videoOwnerChannelId", Json.Encode.string rootItemsObjectSnippet.videoOwnerChannelId )
        , ( "videoOwnerChannelTitle", Json.Encode.string rootItemsObjectSnippet.videoOwnerChannelTitle )
        ]


encodedRootItemsObjectSnippetResourceId : RootItemsObjectSnippetResourceId -> Json.Encode.Value
encodedRootItemsObjectSnippetResourceId rootItemsObjectSnippetResourceId =
    Json.Encode.object
        [ ( "kind", Json.Encode.string rootItemsObjectSnippetResourceId.kind )
        , ( "videoId", Json.Encode.string rootItemsObjectSnippetResourceId.videoId )
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
