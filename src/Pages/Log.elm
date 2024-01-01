module Pages.Log exposing (Model, Msg(..), page)

import Effect exposing (Effect)
import Gen.Params.Log exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Page
import Api.Logging exposing (LogEntry)
import Bridge exposing (sendToBackend, ToBackend(..))
import Element exposing (..)
import UI.Helpers exposing (..)
import Api.Logging exposing (logLevelToString)
import Lamdera.Debug exposing (posixToMillis)
import Api.Logging exposing (posixToString)


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
    { logs : List LogEntry}


init : ( Model, Effect Msg )
init =
    ( { logs = [] }, Effect.fromCmd <| sendToBackend <| AttemptGetLogs )



-- UPDATE


type Msg
    = GotLogs (List LogEntry)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotLogs logs ->
            ( { model | logs = logs }, Effect.none )



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
                ]
            )
    }
