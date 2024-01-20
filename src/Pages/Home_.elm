module Pages.Home_ exposing (Model, Msg(..), page)

import Api.User exposing (isEditor)
import Bridge exposing (..)
import Element
import Gen.Route as Route
import Html exposing (..)
import Page
import Request exposing (Request)
import Shared
import Utils.Route
import View exposing (View)


page : Shared.Model -> Request -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared req
        , update = update shared
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    {}


init : Shared.Model -> Request -> ( Model, Cmd Msg )
init shared req =
    let
        navMsg =
            if shared.user |> isEditor then
                Utils.Route.navigate req.key Route.Example

            else
                Utils.Route.navigate req.key Route.Login
    in
    ( {}
    , navMsg
    )



-- UPDATE


type Msg
    = Noop


update : Shared.Model -> Msg -> Model -> ( Model, Cmd Msg )
update shared msg model =
    case msg of
        Noop ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Home"
    , body =
        Element.none
    }
