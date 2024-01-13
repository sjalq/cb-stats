module Evergreen.V20.Api.Data exposing (..)


type Data value
    = NotAsked
    | Loading
    | Failure String
    | Success value
