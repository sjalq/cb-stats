module Pages.Log exposing (Model, Msg(..), page)

import Api.Logging exposing (LogEntry, logLevelToString, posixToString)
import Bridge exposing (ToBackend(..), sendToBackend)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Input
import Gen.Params.Log exposing (Params)
import Lamdera.Debug exposing (posixToMillis)
import List exposing (length)
import Page
import Request
import Shared
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
    { logs : List LogEntry
    , logIndex : Int
    }


init : ( Model, Effect Msg )
init =
    ( { logs = []
      , logIndex = 0
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetLogs 0 100
    )



-- UPDATE


type Msg
    = GotLogs Int (List LogEntry)
    | GetLogPage Int Int
    | YeetLogs


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotLogs index logs ->
            ( { model
                | logs = logs
                , logIndex = index
              }
            , Effect.none
            )

        GetLogPage index number ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptGetLogs index number )

        YeetLogs ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptYeetLogs )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Logs "
    , body =
        el
            [ centerX
            , centerY
            ]
            (Element.column
                []
                [ Element.text "The ancient scrolls contain all that ye need know about the history of this realm."
                , Element.table
                    tableStyle
                    { data = model.logs
                    , columns =
                        [ Column (Element.text "Timestamp") (px 300) (.timestamp >> posixToString >> wrappedText)
                        , Column (Element.text "Level") (px 200) (.logLevel >> logLevelToString >> wrappedText)
                        , Column (Element.text "Message") (px 600) (.message >> wrappedText)
                        ]
                    }
                , Element.row []
                    [ Element.Input.button
                        (UI.Helpers.buttonStyleMedium ++ [ Element.width (px 100), Element.paddingXY 10 10 ])
                        { onPress = GetLogPage (model.logIndex - 100) 100 |> Just
                        , label = Element.text "Previous"
                        }
                    , Element.Input.button
                        (UI.Helpers.buttonStyleMedium ++ [ Element.width (px 100), Element.paddingXY 10 10 ])
                        { onPress = GetLogPage (model.logIndex + 100) 100 |> Just
                        , label = Element.text "Next"
                        }
                    , Element.Input.button
                        (UI.Helpers.buttonStyleMedium ++ [ Element.width (px 100), Element.paddingXY 10 10 ])
                        { onPress = YeetLogs |> Just
                        , label = Element.text "Yeet logs"
                        }
                    ]
                ]
            )
    }
