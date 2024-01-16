module Json.Auto.ChannelHandle exposing (..)

import Json.Decode



-- Required packages:
-- * elm/json


type alias Root =
    { etag : String
    , items : List RootItemsObject
    , kind : String
    }


type alias RootItemsObject =
    { etag : String
    , id : String
    , kind : String
    }


rootDecoder : Json.Decode.Decoder Root
rootDecoder =
    Json.Decode.map3 Root
        (Json.Decode.field "etag" Json.Decode.string)
        (Json.Decode.field "items" <| Json.Decode.list rootItemsObjectDecoder)
        (Json.Decode.field "kind" Json.Decode.string)


rootItemsObjectDecoder : Json.Decode.Decoder RootItemsObject
rootItemsObjectDecoder =
    Json.Decode.map3 RootItemsObject
        (Json.Decode.field "etag" Json.Decode.string)
        (Json.Decode.field "id" Json.Decode.string)
        (Json.Decode.field "kind" Json.Decode.string)
