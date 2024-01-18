module Pages.Video.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (..)
import Bridge exposing (ToBackend(..))
import Dict
import Effect exposing (Effect)
import Element exposing (..)
import Element.Input as Input
import Gen.Params.Video.Id_ exposing (Params)
import Iso8601
import Lamdera exposing (sendToBackend)
import Lamdera.Debug exposing (posixToMillis)
import List.Extra exposing (group)
import Maybe.Extra exposing (prev)
import Page
import Request
import Shared
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


drawField : String -> String -> Element msg
drawField label value =
    row []
        [ el [ width <| px 200 ] <| text label
        , el [] <| text value
        ]


drawMultilineFieldWithScrollbar : String -> String -> Element Msg
drawMultilineFieldWithScrollbar label value =
    row []
        [ el [ width <| px 200 ] <| text label
        , Input.multiline [ height <| px 200, width <| px 700 ]
            { onChange = \_ -> ReplaceMe
            , placeholder = Nothing
            , label = Input.labelHidden label
            , text = value
            , spellcheck = False
            }
        ]


draw24HourViews videoStatisticsAtTime =
    Element.table []
        { data =
            videoStatisticsAtTime
                |> groupBy (.timestamp >> Iso8601.fromTime >> String.left 16)
                |> Dict.values
                |> List.filterMap (List.sortBy (.timestamp >> posixToMillis) >> List.head)
                |> statsDiff
        , columns =
            [ Column (text "Time") (px 300) (.current >> .timestamp >> Iso8601.fromTime >> String.left 16 >> Element.text)
            , Column (text "Views") (px 100) (.current >> .viewCount >> String.fromInt >> Element.text) 
            , Column (text "Views Delta") (px 120) (.diff >> Maybe.map .viewCountDelta >> Maybe.withDefault 0 >> String.fromInt >> Element.text)
            , Column (text "Likes") (px 100) (.current >> .likeCount >> String.fromInt >> Element.text)
            , Column (text "Dislikes") (px 100) (.current >> .dislikeCount >> Maybe.map String.fromInt >> Maybe.withDefault "" >> Element.text)
            , Column (text "Comments") (px 100) (.current >> .commentCount >> Maybe.map String.fromInt >> Maybe.withDefault "" >> Element.text)
            ]
        }


drawLiveViewers currentViewers =
    Element.table []
        { data =
            currentViewers
                |> groupBy (.timestamp >> Iso8601.fromTime >> String.left 16)
                |> Dict.values
                |> List.filterMap (List.sortBy .value >> List.head)
                |> viewsDiff
        , columns =
            [ Column (text "Time") (px 300) (.current >> .timestamp >> Iso8601.fromTime >> String.left 16 >> Element.text)
            , Column (text "Viewers") (px 100) (.current >> .value >> String.fromInt >> Element.text)
            , Column (text "Delta") (px 100) (.diff >> Maybe.map .valueDelta >> Maybe.withDefault 0 >> String.fromInt >> Element.text)
            ]
        }


view : Model -> View Msg
view model =
    { title = "Video"
    , body =
        column [ width <| px 300 ]
            [ drawField "Title" <| Maybe.withDefault "" <| Maybe.map .title model.video
            , drawMultilineFieldWithScrollbar "Description" <| Maybe.withDefault "" <| Maybe.map .description model.video
            , el [] (Element.image [] { src = Maybe.withDefault "" <| Maybe.andThen .thumbnailUrl model.video, description = "" })
            , drawField "Channel" model.channelTitle
            , drawField "Playlist" model.playlistTitle
            , model.liveVideoDetails |> Maybe.map .scheduledStartTime |> Maybe.withDefault "" |> drawField "Scheduled Start Time"
            , model.liveVideoDetails |> Maybe.andThen .actualStartTime |> Maybe.withDefault "" |> drawField "Actual Start Time"
            , model.liveVideoDetails |> Maybe.andThen .actualEndTime |> Maybe.withDefault "" |> drawField "Actual End Time"
            , drawField "24hr Statistics" ""
            , draw24HourViews model.videoStatisticsAtTime
            , drawField "Live Viewers" ""
            , drawLiveViewers model.currentViewers
            ]
    }


groupBySlow mapping list =
    list
        |> List.map (\l -> ( mapping l, list |> List.filter (\l2 -> mapping l == mapping l2) ))
        |> Dict.fromList



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


groupBy mapping list =
    let
        mappedList =
            List.map (\item -> ( mapping item, item )) list

        sortedList =
            List.sortBy Tuple.first mappedList

        groupAccumulator ( key, value ) acc =
            Dict.update key (\maybeValues -> Just (value :: Maybe.withDefault [] maybeValues)) acc
    in
    List.foldl groupAccumulator Dict.empty sortedList


getFirstTwoLines string =
    string
        |> String.split "\n"
        |> List.take 2
        |> String.join "\n"
