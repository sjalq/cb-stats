module UI.Helpers exposing (..)

import Element 
import Element.Border
import Gen.Route as Route
import Html.Attributes
import Element.Font


enlist : a -> List a
enlist item =
    [ item ]


wrappedCell : Element.Element msg -> Element.Element msg
wrappedCell =
    enlist
        >> Element.paragraph
            [ Element.width <| Element.px 200
            , Element.Border.width 1
            , Element.htmlAttribute (Html.Attributes.style "marginLeft" "auto")
            , Element.htmlAttribute (Html.Attributes.style "marginRight" "auto")

            --, Element.height <| Element.px 26
            ]


wrappedText : String -> Element.Element msg
wrappedText =
    Element.text >> wrappedCell


tableStyle : List (Element.Attribute msg)
tableStyle =
    [ Element.centerX
    , Element.centerY
    , Element.spacing 5
    , Element.padding 10
    , Element.Border.width 1
    ]


idLink linkRouteMsg id text =
    Element.link
        [ Element.centerX, Element.centerY, Element.Font.underline ]
        { url = Route.toHref (linkRouteMsg {id = id} )
        , label = Element.text text
        }
    |> wrappedCell
