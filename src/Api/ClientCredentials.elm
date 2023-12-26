module Api.ClientCredentials exposing (..)

type alias ClientCredentials =
    { accessToken : String
    , refreshToken : String
    , timestamp : Int
    }