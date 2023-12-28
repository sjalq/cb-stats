module Pages.Example exposing (Model, Msg(..), page)

import Api.ClientCredentials exposing (ClientCredentials)
import Api.PerformNow exposing (performNow)
import Bridge exposing (ToBackend(..))
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border
import Element.Input
import Env
import Gen.Params.Example exposing (Params)
import Html.Attributes
import Lamdera exposing (sendToBackend)
import Page
import Request
import Shared
import Time
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
    { clientCredentials : List ClientCredentials
    , currentTime : Time.Posix
    }


init : ( Model, Effect Msg )
init =
    ( { clientCredentials = []
      , currentTime = Time.millisToPosix 0
      }
    , Effect.fromCmd <|
        Cmd.batch
            [ sendToBackend <| AttemptGetCredentials
            , performNow <| Tick
            ]
    )



-- UPDATE


type Msg
    = GotCredentials (List ClientCredentials)
    | GetChannels String
    | Tick Time.Posix


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotCredentials clientCredentials ->
            ( { model | clientCredentials = clientCredentials }, Effect.none )
        
        GetChannels email ->
            ( model
            , Effect.fromCmd <|
                sendToBackend <| AttemptGetChannels email
            )

        Tick posixTime ->
            ( { model | currentTime = posixTime }, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Time.every 1000 Tick
        ]



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

            wrappedCell text =
                Element.paragraph
                    [ Element.width <| Element.px 200
                    , Element.Border.width 1
                    , Element.htmlAttribute (Html.Attributes.style "marginLeft" "auto")
                    , Element.htmlAttribute (Html.Attributes.style "marginRight" "auto")
                    ]
                    [ Element.text text ]
        in
        el
            [ centerX
            , centerY
            ]
            (Element.column
                []
                [ Element.link
                    [ centerX, centerY ]
                    { url = Env.googleOauthUrl
                    , label = Element.text "🦄 Google Auth Yerself! ✨"
                    }
                , Element.table
                    [ Element.centerX
                    , Element.centerY
                    , Element.spacing 5
                    , Element.padding 10
                    , Element.Border.width 1
                    ]
                    { data = model.clientCredentials
                    , columns =
                        [ { header = Element.text "Display Name"
                          , width = px 200
                          , view =
                                \cred ->
                                    wrappedCell cred.displayName
                          }
                        , { header = Element.text "Email Address"
                          , width = px 275
                          , view =
                                \cred ->
                                    wrappedCell cred.email
                          }
                        , { header = Element.text "Refresh Token"
                          , width = px 300 |> maximum 100
                          , view =
                                \cred ->
                                    wrappedCell cred.refreshToken
                          }
                        , { header = Element.text "Access Token"
                          , width = px 500
                          , view =
                                \cred ->
                                    wrappedCell cred.accessToken
                          }
                        , { header = Element.text "Remaining time"
                          , width = px 200
                          , view =
                                \cred ->
                                    let
                                        currentTime_ =
                                            model.currentTime |> Time.posixToMillis

                                        remainingTime =
                                            (cred.timestamp - currentTime_ + 3600000) // 1000

                                        label =
                                            if remainingTime < 0 then
                                                "Expired"

                                            else
                                                String.fromInt remainingTime
                                    in
                                    wrappedCell label
                          }
                        , { header = Element.text "Fetch Channels Button"
                          , width = px 200
                          , view =
                                \cred ->
                                    Element.Input.button
                                        []
                                        { onPress = GetChannels cred.email |> Just
                                        , label = Element.text "Fetch Channels"
                                        }
                          }
                        ]
                    }
                ]
            )
    }
