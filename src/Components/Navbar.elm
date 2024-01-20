module Components.Navbar exposing (view)

import Element
import Element.Border as Border
import Element.Region as Region
import Gen.Route as Route exposing (Route)
import Html exposing (..)
import Html.Attributes


view : Element.Element msg
view =
    Element.el
        [ Region.navigation
        ]
    <|
        Element.row
            []
            []
