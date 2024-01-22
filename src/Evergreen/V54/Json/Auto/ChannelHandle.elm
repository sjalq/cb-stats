module Evergreen.V54.Json.Auto.ChannelHandle exposing (..)


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
