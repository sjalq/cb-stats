module Evergreen.V28.Json.Auto.AccessToken exposing (..)


type alias Root =
    { accessToken : String
    , expiresIn : Int
    , idToken : String
    , scope : String
    , tokenType : String
    }
