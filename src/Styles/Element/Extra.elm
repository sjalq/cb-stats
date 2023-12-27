module Styles.Element.Extra exposing (..)

import Element
import Html
import Html.Attributes


widthPercent : Float -> Element.Attribute msg
widthPercent value =
    Element.htmlAttribute <| Html.Attributes.style "width" ((value |> String.fromFloat) ++ "%")


transition : String -> Element.Attribute msg
transition value =
    Element.htmlAttribute <| Html.Attributes.style "transition" value
