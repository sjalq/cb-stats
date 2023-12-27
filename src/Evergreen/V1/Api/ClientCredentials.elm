module Evergreen.V1.Api.ClientCredentials exposing (..)


type alias ClientCredentials =
    { displayName : String
    , email : String
    , accessToken : String
    , refreshToken : String
    , timestamp : Int
    }
