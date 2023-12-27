module UI.Styled exposing (..)

import Element
import Element.Font as Font
import Styles.Colors exposing (blue, red)


errorMessage : Maybe String -> Element.Element msg
errorMessage maybeMessage =
    case maybeMessage of
        Just message ->
            Element.paragraph
                [ Element.centerX
                , Font.color red
                , Font.size 20
                , Font.light
                , Font.center
                ]
                [ Element.text message ]

        Nothing ->
            Element.el [ Element.height <| Element.px 20 ] Element.none
