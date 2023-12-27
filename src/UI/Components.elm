module UI.Components exposing (..)

import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Styles.Colors exposing (blue, grey)
import Styles.Element.Extra as Element


progressBar : Int -> Int -> Element.Element msg
progressBar current max =
    Element.row [ Element.width Element.fill, Element.spacing 20 ]
        [ Element.el
            [ Element.width Element.fill
            , Element.height <| Element.px 16
            , Background.color <| grey
            , Border.rounded 8
            , Font.size 25
            , Font.light
            ]
          <|
            Element.el
                [ Element.height Element.fill
                , Background.color <| blue
                , Element.widthPercent ((current |> toFloat) * 100 / (max |> toFloat))
                , Border.rounded 8
                , Element.transition "width 0.3s ease-out"
                , Element.width (Element.shrink |> Element.minimum 16)
                ]
                Element.none
        , Element.el [ Element.width <| Element.px 75, Font.alignRight ] <| Element.text ((max - current |> String.fromInt) ++ "s left")
        ]
