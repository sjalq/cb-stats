module Pages.Example exposing (Model, Msg(..), page)

import Api.ClientCredentials exposing (ClientCredentials)
import Bridge exposing (ToBackend(..))
import Effect exposing (Effect)
import Element exposing (..)
import Gen.Params.Example exposing (Params)
import Lamdera exposing (sendToBackend)
import Page
import Request
import Shared
import View exposing (View)
import Env


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
    { clientCredentials : List ClientCredentials }


init : ( Model, Effect Msg )
init =
    ( { clientCredentials = []
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetCredentials
    )



-- UPDATE


type Msg
    = GotCredentials (List ClientCredentials)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotCredentials clientCredentials ->
            ( { model | clientCredentials = clientCredentials }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Elm Land ❤️ Lamdera"
    , body =
        let
            drawCred : ClientCredentials -> Element Msg
            drawCred clientCredentials =
                row
                    [ centerX, centerY ]
                    [ Element.text <| "Refresh token: " ++ clientCredentials.refreshToken
                    , Element.text <| "Access token: " ++ clientCredentials.accessToken
                    , Element.text <| "Timestamp:" ++ String.fromInt clientCredentials.timestamp
                    ]

            drawCredRows : List ClientCredentials -> List (Element Msg)
            drawCredRows clientCredentials =
                List.map drawCred clientCredentials
        in
        el
            [ centerX
            , centerY
            ]
            (Element.column
                []
                ([ Element.link
                    [ centerX, centerY ]
                    { url = Env.googleOauthUrl
                    , label = Element.text "🦄 Google Auth Yerself! ✨"
                    }
                ]
                ++ drawCredRows model.clientCredentials)
            )
    }
