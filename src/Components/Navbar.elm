module Components.Navbar exposing (view)

import Element
import Element.Border as Border
import Element.Region as Region
import Gen.Route as Route exposing (Route)
import Html exposing (..)
import Html.Attributes exposing (class, classList, href)
import Html.Events as Events


view : Element.Element msg
view =
    Element.el
        [ Region.navigation
        ]
    <|
        Element.row
            []
            []
