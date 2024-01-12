module Evergreen.V18.Api.Data exposing (..)


type Data value
    = NotAsked
    | Loading
    | Failure String
    | Success value
