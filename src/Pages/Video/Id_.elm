module Pages.Video.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (..)
import Bridge exposing (ToBackend(..))
import Dict
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background
import Element.Border
import Element.Font
import Element.Input as Input
import Gen.Params.Video.Id_ exposing (Params)
import Html exposing (col)
import Iso8601
import Lamdera exposing (sendToBackend)
import Lamdera.Debug exposing (posixToMillis)
import MoreDict exposing (groupBy)
import Page
import Request
import Shared
import Time
import UI.Helpers exposing (..)
import Utils.Time exposing (..)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init req
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { channelTitle : String
    , playlistTitle : String
    , video : Maybe Video
    , liveVideoDetails : Maybe LiveVideoDetails
    , currentViewers : List CurrentViewers
    , videoStatisticsAtTime : List VideoStatisticsAtTime
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params } =
    ( { channelTitle = ""
      , playlistTitle = ""
      , video = Nothing
      , liveVideoDetails = Nothing
      , currentViewers = []
      , videoStatisticsAtTime = []
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetVideoDetails params.id
    )



-- UPDATE


type Msg
    = ReplaceMe
    | GotVideoDetails Model


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        ReplaceMe ->
            ( model, Effect.none )

        GotVideoDetails videoDetails ->
            ( videoDetails, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


lightBlue =
    rgb 0.9 0.9 1


labelSide str =
    el
        [ width <| px 200
        , height <| fill
        , Element.Background.color lightBlue
        , Element.paddingXY 10 10
        , centerY
        ]
    <|
        text str


leftLabeledElement str el_ =
    column [ paddingTop ]
        [ row
            [ Element.Border.width 1
            , Element.Border.color <| rgb 0.8 0.8 0.8
            ]
            [ labelSide str
            , el_
            ]
        ]


labelOnly str =
    column [ paddingTop ]
        [ row
            [ Element.Border.width 1
            , Element.Border.color <| rgb 0.8 0.8 0.8
            ]
            [ labelSide str
            ]
        ]


drawField : String -> String -> Element msg
drawField label value =
    leftLabeledElement label (el [ Element.paddingXY 10 10, width <| px 640 ] <| text value)


drawImage : String -> String -> Element msg
drawImage label value =
    leftLabeledElement
        label
        (el [] <| Element.image [] { src = value, description = "" })


drawMultilineFieldWithScrollbar : String -> String -> Element Msg
drawMultilineFieldWithScrollbar label value =
    column [ paddingTop ]
        [ row
            [ Element.Border.width 1
            , Element.Border.color <| rgb 0.8 0.8 0.8
            ]
            [ labelSide label
            , Input.multiline [ height <| px 200, width <| px 640 ]
                { onChange = \_ -> ReplaceMe
                , placeholder = Nothing
                , label = Input.labelHidden label
                , text = value
                , spellcheck = False
                }
            ]
        ]


draw24HourViews liveViews actualStartTimeStr videoStatisticsAtTime =
    let
        initialDelta =
            liveViews + (videoStatisticsAtTime |> List.head |> Maybe.map .viewCount |> Maybe.withDefault 0)

        data =
            videoStatisticsAtTime
                |> groupBy (.timestamp >> Iso8601.fromTime >> String.left 16)
                |> Dict.values
                |> List.filterMap (List.sortBy (.timestamp >> posixToMillis) >> List.head)
                |> statsDiff

        initialFromStr =
            (actualStartTimeStr |> String.left 13 |> String.right 2) ++ ":00"

        initialToStr =
            case data of
                first :: [] ->
                    first.current.timestamp
                        |> Time.toHour Time.utc
                        |> format10

                _ :: second :: _ ->
                    second.current.timestamp
                        |> Time.toHour Time.utc
                        |> format10

                _ ->
                    "??:??"

        initialFromToStr = initialFromStr ++ " - " ++ initialToStr
    in
    column [ paddingTop ]
        [ labelOnly "24hr Statistics"
        , Element.table tableStyle
            { data = data
            , columns =
                [ Column
                    (columnHeader "Time")
                    (px 300)
                    (\c -> (c.diff |> Maybe.map (\diff -> diff.fromHourStr ++ " - " ++ diff.toHourStr)) |> Maybe.withDefault initialFromToStr |> wrappedText)
                , Column (columnHeader "Views") (px 100) (.current >> .viewCount >> (+) liveViews >> String.fromInt >> wrappedText)
                , Column (columnHeader "Views (ex live)") (px 120) (.current >> .viewCount >> String.fromInt >> wrappedText)
                , Column (columnHeader "Views Delta") (px 120) (.diff >> Maybe.map .viewCountDelta >> Maybe.withDefault initialDelta >> String.fromInt >> wrappedText)
                , Column (columnHeader "Likes") (px 100) (.current >> .likeCount >> String.fromInt >> wrappedText)
                , Column (columnHeader "Dislikes") (px 100) (.current >> .dislikeCount >> Maybe.map String.fromInt >> Maybe.withDefault "" >> wrappedText)
                , Column (columnHeader "Comments") (px 100) (.current >> .commentCount >> Maybe.map String.fromInt >> Maybe.withDefault "" >> wrappedText)
                ]
            }
        ]


drawLiveViewers currentViewers actualStartTime =
    case currentViewers of
        [] ->
            Element.none

        _ ->
            let
                actualStart =
                    actualStartTime |> Maybe.map strToIntTime |> Maybe.withDefault 0

                offset currentViewerRecord =
                    ((currentViewerRecord.timestamp |> Time.posixToMillis) - actualStart) // second

                pointInTimeStr currentViewerRecord =
                    offset currentViewerRecord |> String.fromInt
            in
            column [ paddingTop ]
                [ labelOnly "Live Viewers"
                , Element.table tableStyle
                    { data =
                        currentViewers
                            |> groupBy (.timestamp >> Iso8601.fromTime >> String.left 19)
                            |> Dict.values
                            |> List.filterMap (List.sortBy .value >> List.head)
                            |> viewsDiff
                    , columns =
                        [ Column
                            (columnHeader "Time (click to watch)")
                            (px 160)
                            (\c ->
                                Element.link
                                    [ Element.Font.underline
                                    , Element.centerY
                                    , Element.centerX
                                    , Element.width fill
                                    , Element.Font.color <| rgb 0.1 0.1 0.8
                                    ]
                                    { url =
                                        "https://www.youtube.com/watch?v="
                                            ++ c.current.videoId
                                            ++ "&t="
                                            ++ (c.prev
                                                    |> Maybe.map pointInTimeStr
                                                    |> Maybe.withDefault "0"
                                               )
                                    , label = c.current |> .timestamp |> Iso8601.fromTime |> String.left 19 |> text
                                    }
                                    |> wrappedCell
                            )
                        , Column (columnHeader "Viewers") (px 100) (.current >> .value >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Delta") (px 100) (.diff >> Maybe.map .valueDelta >> Maybe.withDefault 0 >> String.fromInt >> wrappedText)
                        ]
                    }
                ]


view : Model -> View Msg
view model =
    let
        liveViews =
            model.video |> Maybe.map (\v -> video_liveViews v model.currentViewers) |> Maybe.withDefault Unknown_

        actualStartTimeStr =
            model.liveVideoDetails
                |> Maybe.andThen .actualStartTime
                |> Maybe.withDefault "??:??"
    in
    { title = "Video"
    , body =
        column [ width <| fill ]
            [ drawField "Title" <| Maybe.withDefault "" <| Maybe.map .title model.video
            , drawMultilineFieldWithScrollbar "Description" <| Maybe.withDefault "" <| Maybe.map .description model.video
            , drawImage "Image" (Maybe.withDefault "" <| Maybe.andThen .thumbnailUrl model.video)
            , drawField "Channel" model.channelTitle
            , drawField "Playlist" model.playlistTitle
            , model.liveVideoDetails |> Maybe.map .scheduledStartTime |> Maybe.withDefault "" |> drawField "Scheduled Start Time"
            , model.liveVideoDetails |> Maybe.andThen .actualStartTime |> Maybe.withDefault "" |> drawField "Actual Start Time"
            , model.liveVideoDetails |> Maybe.andThen .actualEndTime |> Maybe.withDefault "" |> drawField "Actual End Time"
            , model.currentViewers |> List.map .value |> List.maximum |> Maybe.map String.fromInt |> Maybe.withDefault "" |> drawField "Max Live Viewers"
            , video_lobbyEstimate
                (model.liveVideoDetails |> Maybe.map (\l_ -> Dict.empty |> Dict.insert l_.videoId l_) |> Maybe.withDefault Dict.empty)
                (model.currentViewers |> currentViewers_ListToDict)
                (model.video |> Maybe.map .id |> Maybe.withDefault "")
                |> Maybe.map String.fromInt
                |> Maybe.withDefault "unknown"
                |> drawField "Lobby Viewers"
            , case liveViews of
                Actual value ->
                    drawField "Live Views" <| (value |> String.fromInt)

                Estimate value ->
                    drawField "Live Views ±" <| (value |> String.fromInt)

                _ ->
                    drawField "Live Views" "unknown"
            , drawField "CTR %" <| (model.video |> Maybe.andThen .ctr |> Maybe.map String.fromFloat |> Maybe.withDefault "unknown")

            -- , model.currentViewers
            --     |> groupBy (.timestamp >> Iso8601.fromTime >> String.left 16)
            --     |> Dict.values
            --     |> List.filterMap (List.sortBy .value >> List.head)
            --     |> List.map .value
            --     |> List.head
            --     |> Maybe.map String.fromInt
            --     |> Maybe.withDefault ""
            --     |> drawField "1 Min Mark Viewers"
            , case liveViews of
                Actual value ->
                    draw24HourViews value actualStartTimeStr model.videoStatisticsAtTime

                Estimate value ->
                    draw24HourViews value actualStartTimeStr model.videoStatisticsAtTime

                _ ->
                    drawField "24 hr views" "pending..."
            , drawLiveViewers
                (model.currentViewers
                    |> List.filter
                        (\cv ->
                            (cv.timestamp |> Time.posixToMillis)
                                >= (model.liveVideoDetails
                                        |> Maybe.andThen .actualStartTime
                                        |> Maybe.map strToIntTime
                                        |> Maybe.withDefault 0
                                   )
                        )
                )
                (model.liveVideoDetails |> Maybe.andThen .actualStartTime)
            ]
    }



--groupByFast : (a -> comparable) -> List a -> Dict.Dict comparable (List a)


diffWithPrev diffFn list =
    list
        |> List.indexedMap
            (\i item ->
                { current = item
                , prev = getIndex (i - 1) list
                , diff = getIndex (i - 1) list |> Maybe.map (\prev_ -> diffFn item prev_)
                }
            )


format10 val =
    (if val < 10 then
        "0" ++ (val |> String.fromInt)

     else
        val |> modBy 24 |> String.fromInt
    )
        ++ ":00"


statsDiff list =
    list
        |> diffWithPrev
            (\thisHr prev_ ->
                { timestamp = thisHr.timestamp
                , viewCount = thisHr.viewCount
                , viewCountDelta = thisHr.viewCount - prev_.viewCount
                , likeCount = thisHr.likeCount - prev_.likeCount
                , dislikeCount = Maybe.map2 (-) thisHr.dislikeCount prev_.dislikeCount
                , favoriteCount = Maybe.map2 (-) thisHr.favoriteCount prev_.favoriteCount
                , commentCount = Maybe.map2 (-) thisHr.commentCount prev_.commentCount
                , fromHourStr = format10 ((prev_.timestamp |> Time.toHour Time.utc) + 1)
                , toHourStr = format10 ((thisHr.timestamp |> Time.toHour Time.utc) + 1)
                }
            )


viewsDiff list =
    list
        |> diffWithPrev
            (\thisViewerCount prev_ ->
                { valueDelta = thisViewerCount.value - prev_.value
                }
            )


getIndex i list =
    if i < 0 then
        Nothing

    else
        list
            |> List.drop i
            |> List.head


paddingTop =
    paddingEach { top = 20, bottom = 0, left = 0, right = 0 }
