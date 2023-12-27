module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    , view
    )

import Api.User exposing (User)
import Bridge exposing (..)
import Browser.Dom
import Browser.Events
import Components.Navbar
import Element
import Element.Region as Region
import Html exposing (..)
import Html.Attributes
import Process
import Request exposing (Request)
import Task
import Time
import View exposing (View)



-- INIT


type alias Flags =
    ()


type alias Model =
    { viewWidth : Float
    , user : Maybe User
    , toastMessage : Maybe String
    }


init : Request -> Flags -> ( Model, Cmd Msg )
init _ json =
    ( Model 0 Nothing Nothing
    , Browser.Dom.getViewport |> Task.perform (\vp -> GotViewWidth vp.viewport.width)
    )



-- UPDATE


type Msg
    = GotViewWidth Float
    | Noop
    | SignInUser User
    | SignOutUser
    | ShowToastMessage String
    | HideToastMessage Time.Posix


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update _ msg model =
    case msg of
        Noop ->
            ( model
            , Cmd.none
            )

        GotViewWidth viewWidth ->
            ( { model | viewWidth = viewWidth }, Cmd.none )

        SignInUser user ->
            ( { model | user = Just user }, Cmd.none )

        SignOutUser ->
            ( { model | user = Nothing }, Cmd.none )

        ShowToastMessage message ->
            ( { model | toastMessage = Just message }, Cmd.none )

        HideToastMessage _ ->
            ( { model | toastMessage = Nothing }, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ model =
    let
        toastMessageTimeout =
            case model.toastMessage of
                Nothing ->
                    Sub.none

                Just _ ->
                    Time.every 3000 HideToastMessage
    in
    Sub.batch
        [ Browser.Events.onResize (\w _ -> w |> toFloat |> GotViewWidth)
        , toastMessageTimeout
        ]



-- VIEW


view :
    Request
    -> { page : View msg, toMsg : Msg -> msg }
    -> Model
    -> View msg
view req { page, toMsg } model =
    { title = page.title
    , body =
        let
            ( toastMessage, toastMessageClass ) =
                case model.toastMessage of
                    Nothing ->
                        ( "", "" )

                    Just message ->
                        ( message, "show" )
        in
        Element.column
            [ Element.width (Element.fill |> Element.maximum 1280), Element.centerX, Element.paddingXY 30 30 ]
            [ Components.Navbar.view
            , Element.el [ Region.mainContent, Element.width Element.fill ] page.body
            , Element.html <|
                Html.div
                    [ Html.Attributes.id "snackbar"
                    , Html.Attributes.class toastMessageClass
                    ]
                    [ Html.text toastMessage ]
            ]
    }
