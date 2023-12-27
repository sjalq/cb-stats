module Pages.End exposing (Model, Msg(..), page)

import Effect exposing (Effect)
import Element
import Element.Font as Font
import Gen.Params.End exposing (Params)
import Html.Attributes
import Page
import Request
import Shared
import Styles.Colors exposing (blue)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    {}


init : ( Model, Effect Msg )
init =
    ( {}, Effect.none )



-- UPDATE


type Msg
    = ReplaceMe


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Thank you!"
    , body =
        Element.column
            [ Element.centerX
            , Element.spacing 50
            , Element.htmlAttribute <|
                Html.Attributes.style "min-height" "calc(100vh - 60px)"
            ]
            [ Element.el [ Font.size 50, Font.bold, Font.color blue, Font.center, Element.centerX, Element.centerY ] <| Element.text "Thank you!"
            , Element.paragraph [ Font.size 50, Font.bold, Font.center, Element.centerX, Element.centerY ] [ Element.text "You can close this tab." ]
            ]
    }
