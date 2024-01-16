module Json.Auto.PlaylistItems exposing (..)

import Json.Decode



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
    , thumbnails : Maybe RootItemsObjectSnippetThumbnails
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
                (Json.Decode.maybe <| Json.Decode.field "thumbnails" rootItemsObjectSnippetThumbnailsDecoder)
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
