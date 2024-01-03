module Pages.Example exposing (Model, Msg(..), page)

import Api.PerformNow exposing (performNowWithTime)
import Api.YoutubeModel exposing (ClientCredentials)
import Base64
import Bridge exposing (ToBackend(..))
import Bytes.Encode
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border
import Element.Font exposing (underline)
import Element.Input
import Env
import Gen.Params.Example exposing (Params)
import Gen.Route as Route
import Html.Attributes
import Lamdera exposing (sendToBackend)
import Page
import Request
import Shared
import Time
import UI.Helpers exposing (..)
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
            , performNowWithTime <| Tick
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
                sendToBackend <|
                    AttemptGetChannels email
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
    { title = "Banter Stats - Accounts"
    , body =
        el
            [ centerX
            , centerY
            ]
            (Element.column
                []
                -- [ Element.link
                --     ( buttonStyle ++  buttonHoverStyle)
                --     { url = Env.googleOauthUrl
                --     , label = Element.text "🦄 Google Auth Yerself! ✨"
                --     }
                [ linkButton "🦄 Google Auth Yerself! ✨" Env.googleOauthUrl
                , el [ paddingXY 0 10 ] <|
                    Element.table
                        tableStyle
                        { data = model.clientCredentials
                        , columns =
                            [ Column (columnHeader "Display Name") (px 200) (.displayName >> wrappedText)
                            , Column (columnHeader "Email Address") (px 275) (.email >> wrappedText)
                            , Column (columnHeader "Refresh Token") (px 300 |> maximum 100) (.refreshToken >> wrappedText)
                            , Column (columnHeader "Access Token") (px 400) (.accessToken >> wrappedText)
                            , Column
                                (columnHeader "Remaining time")
                                (px 200)
                                (\cred ->
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
                                    wrappedText label
                                )
                            , Column
                                (Element.text "")
                                (px 200)
                                (\cred ->
                                    linkButton
                                        "Channels"
                                    <|
                                        Route.toHref <|
                                            Route.Ga__Email_
                                                { email = cred.email |> Base64.encode }
                                )
                            ]
                        }
                ]
            )
    }
