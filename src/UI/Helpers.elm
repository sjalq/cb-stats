module UI.Helpers exposing (..)

import Element exposing (..)
import Element.Background as Background
import Element.Border
import Element.Font 
import Element.Input
import Gen.Route as Route
import Html.Attributes
import Styles.Colors exposing (..)
import Styles.Element.Extra as Element


enlist : a -> List a
enlist item =
    [ item ]


wrappedCell : Element.Element msg -> Element.Element msg
wrappedCell =
    enlist
        >> Element.paragraph
            [ Element.width <| Element.px 200
            , Element.Font.size 15
            , Element.Border.width 1
            , Element.Border.widthEach
                { bottom = 1
                , left = 1
                , right = 1
                , top = 1
                }
            , Element.height <| Element.fill
            , Element.htmlAttribute (Html.Attributes.style "marginLeft" "auto")
            , Element.htmlAttribute (Html.Attributes.style "marginRight" "auto")
            ]


wrappedText : String -> Element.Element msg
wrappedText =
    Element.text >> wrappedCell


pulsingText : String -> Element.Element msg
pulsingText text =
    el
        [ htmlAttribute <| Html.Attributes.style "@keyframes pulse" "0% { color: black; } 100% { color: white; }"
        , htmlAttribute <| Html.Attributes.style "animation" "pulse 0.5s infinite alternate"
        ]
        (Element.text text)
    

tableStyle : List (Element.Attribute msg)
tableStyle =
    [ Element.centerX
    , Element.centerY
    , Element.spacingXY 5 5
    , Element.paddingXY 10 20
    , Element.Border.width 2
    , Element.Border.rounded 5
    ]


columnHeader : String -> Element.Element msg
columnHeader =
    let
        columnHeaderStyle =
            [ Element.Font.bold
            , Element.Font.size 15
            , Element.Border.width 1
            , Element.Border.color grey
            , Element.Border.rounded 3
            , Element.paddingXY 5 5
            , Element.centerY
            ]
    in
    Element.el
        columnHeaderStyle
        << Element.text


idLink linkRouteMsg id text =
    Element.link
        [ Element.centerX, Element.centerY, Element.Font.underline ]
        { url = Route.toHref (linkRouteMsg { id = id })
        , label = Element.text text
        }
        |> wrappedCell


columnStyle =
    [ Element.centerX
    , Element.width <| Element.maximum 600 Element.fill
    , Element.htmlAttribute <| Html.Attributes.style "min-height" "calc(100vh - 60px)"
    , Element.spacing 50
    ]


rowStyle =
    [ Element.width Element.fill
    , Element.centerY
    , Background.color lightGrey
    , Element.Border.rounded 5
    ]


titleStyle =
    [ Element.Font.size 36
    , Element.Font.bold
    , Element.Font.center
    , Element.centerX
    , Element.centerY
    , paddingXY 10 10
    ]


buttonStyleBig =
    [ Element.centerX
    , Element.centerY
    , Element.width Element.fill
    , Background.color black
    , Element.height <| Element.px 75
    , Element.Border.rounded 20
    , Element.Font.color white
    , Element.Font.size 16
    , Element.transition "all 0.5s ease-out"
    , Element.Border.width 1
    , Element.Border.color black
    ]


buttonStyleMedium =
    [ Element.centerX
    , Element.centerY
    , Element.width Element.fill
    , Background.color black
    , Element.height <| Element.px 50
    , Element.Border.rounded 20
    , Element.Font.color white
    , Element.Font.size 16
    , Element.transition "all 0.1s ease-out"
    , Element.Border.width 1
    , Element.Border.color black
    ]


buttonHoverStyle =
    [ Element.mouseOver
        [ Element.Font.color black
        , Background.color darkGrey
        , Element.Border.color grey
        ]
    ]


linkStyle =
    [ Element.Font.color darkGrey
    , Element.Font.underline
    ]


centerCenter =
    [ Element.centerX
    , Element.centerY
    ]


linkButton : String -> String -> Element.Element msg
linkButton text url =
    Element.link
        (buttonStyleBig ++ buttonHoverStyle)
        { label = Element.el centerCenter (Element.text text)
        , url = url
        }


msgButton : String -> Maybe msg -> Element.Element msg
msgButton text msg =
    Element.Input.button
        (buttonStyleBig ++ buttonHoverStyle)
        { label = Element.el centerCenter (Element.text text)
        , onPress = msg
        }
