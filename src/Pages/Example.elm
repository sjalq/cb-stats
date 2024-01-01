module Pages.Example exposing (Model, Msg(..), page)

import Api.PerformNow exposing (performNowWithTime)
import Api.YoutubeModel exposing (ClientCredentials)
import Bridge exposing (ToBackend(..))
import Bytes.Encode
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border
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
import View exposing (View)
import Base64 
import Element.Font exposing (underline)
import UI.Helpers exposing (..)

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
    { title = "Elm Land ❤️ Lamdera"
    , body =
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
                    tableStyle
                    { data = model.clientCredentials
                    , columns = 
                        [ Column (Element.text "Display Name") (px 200) (.displayName >> wrappedText)
                        , Column (Element.text "Email Address") (px 275) (.email >> wrappedText)
                        , Column (Element.text "Refresh Token") (px 300 |> maximum 100) (.refreshToken >> wrappedText)
                        , Column (Element.text "Access Token") (px 500) (.accessToken >> wrappedText)
                        , Column (Element.text "Remaining time") (px 200) (\cred -> 
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
                            (Element.text "Fetch Channels Button") 
                            (px 200)
                            (\cred -> 
                                [ Element.link 
                                    [ centerX, centerY, underline ]
                                    { url =
                                        Route.toHref
                                            (Route.Ga__Email_
                                                { email = cred.email |> Base64.encode
                                                }
                                            ) 
                                    , label = Element.text cred.email
                                    } ]
                                    |> wrappedCell
                            )
                        ]
                    }
                ]
            )
    }
                    -- columns =
                    --     [ { header = Element.text "Display Name"
                    --       , width = px 200
                    --       , view =
                    --             \cred ->
                    --                 wrappedCell cred.displayName
                    --       }
                    --     , { header = Element.text "Email Address"
                    --       , width = px 275
                    --       , view =
                    --             \cred ->
                    --                 wrappedCell cred.email
                    --       }
                    --     , { header = Element.text "Refresh Token"
                    --       , width = px 300 |> maximum 100
                    --       , view =
                    --             \cred ->
                    --                 wrappedCell cred.refreshToken
                    --       }
                    --     , { header = Element.text "Access Token"
                    --       , width = px 500
                    --       , view =
                    --             \cred ->
                    --                 wrappedCell cred.accessToken
                    --       }
                    --     , { header = Element.text "Remaining time"
                    --       , width = px 200
                    --       , view =
                    --             \cred ->
                    --                 let
                    --                     currentTime_ =
                    --                         model.currentTime |> Time.posixToMillis

                    --                     remainingTime =
                    --                         (cred.timestamp - currentTime_ + 3600000) // 1000

                    --                     label =
                    --                         if remainingTime < 0 then
                    --                             "Expired"

                    --                         else
                    --                             String.fromInt remainingTime

                    --                     -- ++ " "
                    --                     -- ++ String.fromInt cred.timestamp
                    --                     -- ++ " "
                    --                     -- ++ String.fromInt currentTime_
                    --                 in
                    --                 wrappedCell label
                    --       }
                    --     , { header = Element.text "Fetch Channels Button"
                    --       , width = px 200
                    --       , view =
                    --             \cred ->
                    --                 Element.link [ centerX, centerY, underline ]
                    --                     { url =
                    --                         Route.toHref
                    --                             (Route.Ga__Email_
                    --                                 { email = cred.email |> Base64.encode
                    --                                 }
                    --                             )
                    --                     , label = Element.text "Channels"
                    --                     }
                    --       }
                
    --         )
    -- }
