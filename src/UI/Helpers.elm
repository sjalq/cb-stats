module UI.Helpers exposing (..)

import Element 
import Element.Border
import Html.Attributes 

wrappedCell : List (Element.Element msg) -> Element.Element msg
wrappedCell =
    Element.paragraph
        [ Element.width <| Element.px 200
        , Element.Border.width 1
        , Element.htmlAttribute (Html.Attributes.style "marginLeft" "auto")
        , Element.htmlAttribute (Html.Attributes.style "marginRight" "auto")
        --, Element.height <| Element.px 26
        ]
       

wrappedText : String -> Element.Element msg
wrappedText text =
    [Element.text text] |> wrappedCell


tableStyle : List (Element.Attribute msg)
tableStyle =
    [ Element.centerX
    , Element.centerY
    , Element.spacing 5
    , Element.padding 10
    , Element.Border.width 1
    ]
