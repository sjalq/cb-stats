module Evergreen.V54.Json.Auto.Channels exposing (..)


type alias RootItemsObjectSnippetLocalized =
    { description : String
    , title : String
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


type alias RootItemsObjectSnippetThumbnails =
    { default : RootItemsObjectSnippetThumbnailsDefault
    , high : RootItemsObjectSnippetThumbnailsHigh
    , medium : RootItemsObjectSnippetThumbnailsMedium
    }


type alias RootItemsObjectSnippet =
    { customUrl : String
    , description : String
    , localized : RootItemsObjectSnippetLocalized
    , publishedAt : String
    , thumbnails : RootItemsObjectSnippetThumbnails
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
