module Pages.Home_ exposing (Model, Msg(..), page)

import Env
import Bridge
import Effect exposing (..)
import Element exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Lamdera
import Page exposing (Page)
import Route exposing (Route)
import Shared
import View exposing (View)


page : Shared.Model -> Route () -> Page Model Msg
page shared route =
    Page.new
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view shared
        }



-- INIT


type alias Model =
    {}


init : () -> ( Model, Effect Msg )
init _ =
    ( {}
    , Effect.none
    )



-- UPDATE


type Msg
    = SmashedLikeButton


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        SmashedLikeButton ->
            ( model
            , Effect.sendCmd <| Lamdera.sendToBackend Bridge.SmashedLikeButton
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Elm Land ❤️ Lamdera"
    , attributes = []
    , element =
        el [ centerX 
           , centerY
           ]
           (
            Element.column 
                []
                [ Element.link 
                    [] 
                    { url = Env.googleOauthUrl
                    , label = Element.text "Hello, Elm UI! ✨"  
                    } 
                , Element.text <| "Refresh token: " ++ shared.refreshToken
                , Element.text <| "Access token: " ++ shared.accessToken
                , Element.text <| "Timestamp:" ++ (String.fromInt shared.timestamp)
                ]
           )
    }

    -- [ node "style" [] [ text """
    --     @import url('https://fonts.googleapis.com/css2?family=Lora:wght@600&family=Nunito+Sans&display=swap');
    --     html {
    --         height: 100%;
    --         color: white;
    --         background: linear-gradient(dodgerblue, #339);
    --     }
    --     body {
    --         display: flex;
    --         flex-direction: column;
    --         margin: 0;
    --         justify-content: center;
    --         align-items: center;
    --         height: 90vh;
    --         font-family: 'Lora';
    --     }
    --     h1 {
    --         margin: 0;
    --         font-weight: 600 !important;
    --     }
    --     """ ]
    -- , div [ style "display" "flex", style "gap" "1rem" ]
    --     [ img
    --         [ alt "Lando, the Elm Land Rainbow"
    --         , src "https://elm.land/images/logo-480.png"
    --         , style "width" "128px"
    --         , style "margin-right" "2.5rem"
    --         ]
    --         []
    --     , img
    --         [ alt "Laurie, the Lamdera Lambda Llamba"
    --         , src "https://lamdera.com/images/llama/floaty.png"
    --         , style "width" "81.4px"
    --         , style "margin-right" "1.5rem"
    --         , style "height" "108.4px"
    --         ]
    --         []
    --     ]
    -- , h1 [] [ text "Elm Land ❤️ Lamdera" ]
    -- , p
    --     [ style "font-family" "Nunito Sans"
    --     , style "opacity" "0.75"
    --     ]
    --     [ text "It's working, Mario!!" ]
    -- , p
    --     [ style "font-family" "Nunito Sans"
    --     , style "cursor" "pointer"
    --     , style "background-color" "#ffffff40"
    --     , style "padding" "5px"
    --     , style "border-radius" "5px"
    --     , style "user-select" "none"
    --     , onClick SmashedLikeButton
    --     ]
    --     [ text <| "👍 " ++ String.fromInt shared.smashedLikes ]
    -- , a [ href "http://localhost:3001/api/auth/google" ]
    --     [ img
    --         [ alt "Lamdera Logo"
    --         , src "https://lamdera.com/images/lamdera-logo.svg"
    --         , style "width" "128px"
    --         ]
    --         []
    --     ]
    -- ]
    -- }
