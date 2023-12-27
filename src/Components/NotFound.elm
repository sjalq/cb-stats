module Components.NotFound exposing (view)

import Element exposing (Element)
import Element.Font as Font
import Element.Region as Region


view : Element msg
view =
    Element.column []
        [ Element.el
            [ Region.heading 1
            ]
          <|
            Element.text "Page not found."
        , Element.link [ Region.heading 5, Font.underline ]
            { url = "/"
            , label = Element.text "But here's the homepage!"
            }
        ]
