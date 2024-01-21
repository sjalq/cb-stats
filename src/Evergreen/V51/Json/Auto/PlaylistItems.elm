module Evergreen.V51.Json.Auto.PlaylistItems exposing (..)


type alias RootItemsObjectSnippetResourceId =
    { kind : String
    , videoId : String
    }


type alias RootItemsObjectSnippetThumbnailsStandard =
    { height : Int
    , url : String
    , width : Int
    }


type alias RootItemsObjectSnippetThumbnails =
    { standard : RootItemsObjectSnippetThumbnailsStandard
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
    , videoOwnerChannelId : Maybe String
    , videoOwnerChannelTitle : Maybe String
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
    , nextPageToken : Maybe String
    , pageInfo : RootPageInfo
    }
