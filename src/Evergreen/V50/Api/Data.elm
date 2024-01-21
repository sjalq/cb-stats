module Evergreen.V50.Api.Data exposing (..)


type Data value
    = NotAsked
    | Loading
    | Failure String
    | Success value
