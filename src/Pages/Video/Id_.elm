module Pages.Video.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (..)
import Bridge exposing (ToBackend(..))
import Dict
import Effect exposing (Effect)
import Element exposing (..)
import Gen.Params.Video.Id_ exposing (Params)
import Iso8601
import Lamdera exposing (sendToBackend)
import Lamdera.Debug exposing (posixToMillis)
import List.Extra exposing (group)
import Page
import Request
import Shared
import Utils.Time exposing (..)
import View exposing (View)
import Element.Input as Input


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
        , Input.multiline [ height <| px 200, width <| px 700]
            { onChange = (\_ -> ReplaceMe)
            , placeholder = Nothing
            , label = Input.labelHidden label
            , text = value
            , spellcheck = False
            }
        ]


draw24HourViews : List VideoStatisticsAtTime -> Element msg
draw24HourViews videoStatisticsAtTime =
    Element.table []
        { data =
            videoStatisticsAtTime
                |> groupBy (.timestamp >> Iso8601.fromTime >> String.left 16)
                |> Dict.values
                |> List.filterMap (List.sortBy (.timestamp >> posixToMillis) >> List.head)
        , columns =
            [ Column (text "Time") (px 300) (.timestamp >> Iso8601.fromTime >> String.left 13 >> (\t -> t ++ ":00 ") >> Element.text)
            , Column (text "Views") (px 100) (.viewCount >> String.fromInt >> Element.text)
            , Column (text "Likes") (px 100) (.likeCount >> String.fromInt >> Element.text)
            , Column (text "Dislikes") (px 100) (.dislikeCount >> Maybe.map String.fromInt >> Maybe.withDefault "" >> Element.text)
            , Column (text "Comments") (px 100) (.commentCount >> Maybe.map String.fromInt >> Maybe.withDefault "" >> Element.text)
            ]
        }


drawLiveViewers : List CurrentViewers -> Element msg
drawLiveViewers currentViewers =
    Element.table []
        { data =
            currentViewers
                |> groupBy (.timestamp >> Iso8601.fromTime >> String.left 16)
                |> Dict.values
                |> List.filterMap (List.sortBy .value >> List.head)
        , columns =
            [ Column (text "Time") (px 300) (.timestamp >> Iso8601.fromTime >> String.left 16 >> Element.text)
            , Column (text "Viewers") (px 100) (.value >> String.fromInt >> Element.text)
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
            , model.liveVideoDetails |> Maybe.andThen .actualEndTime |> Maybe.withDefault "" |> drawField "Current Viewers"
            , draw24HourViews model.videoStatisticsAtTime
            , drawLiveViewers model.currentViewers
            ]
    }


groupBySlow mapping list =
    list
        |> List.map (\l -> ( mapping l, list |> List.filter (\l2 -> mapping l == mapping l2) ))
        |> Dict.fromList



--groupByFast : (a -> comparable) -> List a -> Dict.Dict comparable (List a)


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
