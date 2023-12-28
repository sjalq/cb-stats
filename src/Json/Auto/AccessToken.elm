module Json.Auto.AccessToken exposing (..)

import Json.Decode
import Json.Encode


-- Required packages:
-- * elm/json


type alias Root =
    { accessToken : String
    , expiresIn : Int
    , idToken : String
    , scope : String
    , tokenType : String
    }


rootDecoder : Json.Decode.Decoder Root
rootDecoder = 
    Json.Decode.map5 Root
        (Json.Decode.field "access_token" Json.Decode.string)
        (Json.Decode.field "expires_in" Json.Decode.int)
        (Json.Decode.field "id_token" Json.Decode.string)
        (Json.Decode.field "scope" Json.Decode.string)
        (Json.Decode.field "token_type" Json.Decode.string)


encodedRoot : Root -> Json.Encode.Value
encodedRoot root = 
    Json.Encode.object
        [ ( "access_token", Json.Encode.string root.accessToken )
        , ( "expires_in", Json.Encode.int root.expiresIn )
        , ( "id_token", Json.Encode.string root.idToken )
        , ( "scope", Json.Encode.string root.scope )
        , ( "token_type", Json.Encode.string root.tokenType )
        ]