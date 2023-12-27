module Pages.Admin exposing (Model, Msg(..), page)

import Api.User exposing (isAdmin)
import Effect exposing (Effect)
import Element as Element
import Gen.Params.Admin exposing (Params)
import Page
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update
        , view = view shared
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


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Admin"
    , body =
        if shared.user |> isAdmin then
            Element.text "Admin dashboard coming soon..."

        else
            Element.text "You are not authorized to view this page"
    }
