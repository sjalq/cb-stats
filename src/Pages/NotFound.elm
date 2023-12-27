module Pages.NotFound exposing (view)

import Components.NotFound
import Element exposing (Element)
import Html exposing (..)


view : { title : String, body : Element msg }
view =
    { title = "404"
    , body =
        Components.NotFound.view
    }
