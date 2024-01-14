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
      ---
    | Batch_RefreshAccessTokens
    | Batch_RefreshAllChannels
    | Batch_RefreshAllPlaylists
    | Batch_RefreshAllVideosFromPlaylists
    | Batch_GetLiveVideoStreamData
    | Batch_GetVideoStats
    | Batch_GetVideoDailyReports
    | Batch_GetChatMessages
    | Batch_GetVideoStatisticsAtTime


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

        Batch_RefreshAccessTokens ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptBatch_RefreshAccessTokens )

        Batch_RefreshAllChannels ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptBatch_RefreshAllChannels )

        Batch_RefreshAllPlaylists ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptBatch_RefreshAllPlaylists )

        Batch_RefreshAllVideosFromPlaylists ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptBatch_RefreshAllVideosFromPlaylists )

        Batch_GetLiveVideoStreamData ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptBatch_GetLiveVideoStreamData )

        Batch_GetVideoStats ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptBatch_GetVideoStats )

        Batch_GetVideoDailyReports ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptBatch_GetVideoDailyReports )

        Batch_GetChatMessages ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptBatch_GetChatMessages )

        Batch_GetVideoStatisticsAtTime ->
            ( model, Effect.fromCmd <| sendToBackend <| AttemptBatch_GetVideoStatisticsAtTime )



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
                ([ Element.text "The ancient scrolls contain all that ye need know about the history of this realm."
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
                    [ msgButton "Previous" (GetLogPage (model.logIndex - 100) 100 |> Just)
                    , msgButton "Next" (GetLogPage (model.logIndex + 100) 100 |> Just)
                    , msgButton "Yeet" (Just YeetLogs)
                    ]
                 ]
                    ++ ([ msgButton "Refresh access tokens" (Just Batch_RefreshAccessTokens)
                        , msgButton "Refresh all channels" (Just Batch_RefreshAllChannels)
                        , msgButton "Refresh all playlists" (Just Batch_RefreshAllPlaylists)
                        , msgButton "Refresh all videos from playlists" (Just Batch_RefreshAllVideosFromPlaylists)
                        , msgButton "Get live video stream data" (Just Batch_GetLiveVideoStreamData)
                        , msgButton "Get video stats" (Just Batch_GetVideoStats)
                        , msgButton "Get video daily reports" (Just Batch_GetVideoDailyReports)
                        , msgButton "Get chat messages" (Just Batch_GetChatMessages)
                        , msgButton "Get video statistics at time" (Just Batch_GetVideoStatisticsAtTime)
                        ]
                            |> List.map (\x -> Element.row [ Element.paddingXY 1 1, width (px 400) ] [ x ])
                       )
                )
            )
    }
