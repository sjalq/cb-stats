module StringDict exposing (..)

import Dict


type Value 
    = Nothing
    | Value String
    | Dict (Dict.Dict String Value)

type StringDict = Dict.Dict String Value

i key value dict =
    Dict.insert key value dict
    
g key dict =
    case Dict.get key dict of
        Just value ->
            value

        Nothing ->
            Value.Nothing

gs key dict =
    case Dict.get key dict of
        Just value ->
            case value of
                Value value_ ->
                    value_

                Dict _ ->
                    "{object}"

                _ ->
                    ""

        Nothing ->
            Value.Dict Dict.empty

empty : Dict.Dict String Value
empty =
    Dict.empty

example =
    empty 
        |> i "a" "b" 
        |> i "c" "d" 
        |> i "e" "f" 
        |> i "g" 
            (Dict.empty 
                |> i "h" "i" 
                |> i "j" "k" 
                |> i "l" "m")

map : (String -> Value -> Value) -> StringDict -> StringDict
map f dict =
    Dict.map f dict