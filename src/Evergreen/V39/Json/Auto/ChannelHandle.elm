module Evergreen.V39.Json.Auto.ChannelHandle exposing (..)


type alias RootItemsObject =
    { etag : String
    , id : String
    , kind : String
    }


type alias Root =
    { etag : String
    , items : List RootItemsObject
    , kind : String
    }
