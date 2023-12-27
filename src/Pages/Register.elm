module Pages.Register exposing (Field(..), Model, Msg(..), page)

import Api.Data exposing (Data(..))
import Api.User exposing (User, validateUser)
import Bridge exposing (ToBackend(..), sendToBackend)
import Effect exposing (Effect)
import Element
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Gen.Params.Register exposing (Params)
import Gen.Route as Route
import Html.Attributes
import Page
import Pages.Login exposing (Msg(..))
import Request exposing (Request)
import Shared
import Styles.Colors exposing (black, darkGrey, grey, lightGrey, white)
import Styles.Element.Extra as Element
import UI.Styled as Styled
import Utils.Route
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init
        , update = update req
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { email : String
    , password : String
    , errorMessage : Maybe String
    , showPassword : Bool
    }


init : ( Model, Effect Msg )
init =
    ( Model "" "" Nothing False, Effect.none )



-- UPDATE


type Msg
    = Updated Field String
    | ToggledShowPassword
    | ClickedSubmit
    | GotUser (Data User)


type Field
    = Email
    | Password


update : Request -> Msg -> Model -> ( Model, Effect Msg )
update req msg model =
    case msg of
        Updated Email email ->
            ( { model | email = email }, Effect.none )

        Updated Password password ->
            ( { model | password = password }, Effect.none )

        ToggledShowPassword ->
            ( { model | showPassword = not model.showPassword }, Effect.none )

        ClickedSubmit ->
            let
                newUser =
                    { email = model.email
                    , password = model.password
                    }

                ( validEmail, validPass ) =
                    validateUser newUser
            in
            case ( validEmail, validPass ) of
                ( True, True ) ->
                    ( { model | errorMessage = Nothing }, Effect.fromCmd <| sendToBackend <| AttemptRegistration <| newUser )

                ( False, _ ) ->
                    ( { model | errorMessage = Just "Please enter a valid email address" }, Effect.none )

                ( _, False ) ->
                    ( { model | errorMessage = Just "Please enter a valid password" }, Effect.none )

        GotUser userData ->
            case userData of
                Success user ->
                    ( { model | email = "", password = "", errorMessage = Nothing }
                    , Effect.fromCmd <| Utils.Route.navigate req.key Route.Example
                    )

                Failure error ->
                    ( { model | errorMessage = Just error }, Effect.none )

                _ ->
                    ( { model | errorMessage = Just "Something went wrong" }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Login"
    , body =
        Element.column
            [ Element.centerX
            , Element.width <| Element.maximum 600 Element.fill
            , Element.htmlAttribute <|
                Html.Attributes.style "min-height" "calc(100vh - 60px)"
            , Element.spacing 50
            ]
            [ Element.el [ Font.size 36, Font.bold, Font.center, Element.centerX, Element.centerY ] <| Element.text "Create Account"
            , Element.column [ Element.spacing 15, Element.width Element.fill ]
                [ Input.email
                    [ Element.centerY
                    , Element.width Element.fill
                    , Border.width 0
                    , Background.color lightGrey
                    , Font.size 20
                    , Font.light
                    , Element.padding 25
                    , Element.focused []
                    , Border.rounded 5
                    ]
                    { onChange = Updated Email
                    , label = Input.labelHidden "email"
                    , text = model.email
                    , placeholder = Just <| Input.placeholder [] <| Element.text "Email"
                    }
                , Element.row
                    [ Element.width Element.fill
                    , Element.centerY
                    , Background.color lightGrey
                    , Border.rounded 5
                    ]
                    [ Input.newPassword
                        [ Element.width Element.fill
                        , Border.width 0
                        , Background.color lightGrey
                        , Font.size 20
                        , Font.light
                        , Element.padding 25
                        , Element.focused []
                        , Border.rounded 5
                        ]
                        { onChange = Updated Password
                        , label = Input.labelHidden "password"
                        , text = model.password
                        , placeholder = Just <| Input.placeholder [] <| Element.text "Password"
                        , show = model.showPassword
                        }
                    , Input.button
                        [ Element.width <| Element.px 100, Element.focused [] ]
                        { onPress = Just ToggledShowPassword
                        , label =
                            Element.image [ Element.centerX ] { src = "/eye.svg", description = "" }
                        }
                    ]
                , Element.el [ Element.centerY, Element.centerX ] <| Styled.errorMessage model.errorMessage
                ]
            , Input.button
                [ Element.centerX
                , Element.centerY
                , Element.width Element.fill
                , Background.color black
                , Element.height <| Element.px 75
                , Border.rounded 20
                , Font.color white
                , Font.size 22
                , Element.transition "all 0.1s ease-out"
                , Border.width 1
                , Border.color black
                , Element.mouseOver
                    [ Font.color black
                    , Background.color white
                    , Border.color grey
                    ]
                ]
                { onPress = Just ClickedSubmit
                , label = Element.el [ Element.centerX, Element.centerY ] <| Element.text "Sign up"
                }
            , Element.row [ Element.centerX, Element.spacing 10, Element.centerY ]
                [ Element.text "Already have an account?"
                , Element.link [ Font.color darkGrey, Font.underline ] { url = "/login", label = Element.text "Log in" }
                ]
            ]
    }
