module Pages.Playlist.Id_ exposing (Model, Msg(..), page)

import Utils.Time exposing (..)
import Api.YoutubeModel exposing (CurrentViewers, LiveStatus(..), LiveVideoDetails, Playlist, Video, VideoStatisticsAtTime)
import Bridge exposing (..)
import Dict exposing (Dict)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border
import Element.Font
import Gen.Params.Playlist.Id_ exposing (Params)
import Page
import Request
import Shared
import Styles.Colors
import Svg
import Svg.Attributes
import Time exposing (posixToMillis)
import UI.Helpers exposing (..)
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
    { playlistId : String
    , playlistTitle : String
    , videos : Dict String Video
    , liveVideoDetails : Dict String LiveVideoDetails
    , currentViewers : Dict ( String, Int ) CurrentViewers
    , videoChannels : Dict String String
    , playlists : Dict String Playlist
    , videoStats : Dict ( String, Int ) Api.YoutubeModel.VideoStatisticsAtTime
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params } =
    ( { videos = Dict.empty
      , playlistId = params.id
      , playlistTitle = ""
      , liveVideoDetails = Dict.empty
      , currentViewers = Dict.empty
      , videoChannels = Dict.empty
      , playlists = Dict.empty
      , videoStats = Dict.empty
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetVideos params.id
    )



-- UPDATE


type Msg
    = GotVideos (Dict String Playlist) (Dict String Video) (Dict String LiveVideoDetails) (Dict ( String, Int ) CurrentViewers) (Dict String String) (Dict ( String, Int ) VideoStatisticsAtTime)
    | GetVideos


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotVideos playlists videos liveVideoDetails currentViewers videoChannels videoStats ->
            ( { model
                | videos = videos
                , playlistTitle =
                    if Dict.size playlists == 1 then
                        playlists |> Dict.values |> List.head |> Maybe.map .title |> Maybe.withDefault "Unknown"

                    else
                        "All monitored playlists"
                , liveVideoDetails = liveVideoDetails
                , currentViewers = currentViewers
                , videoChannels = videoChannels
                , playlists = playlists
                , videoStats = videoStats
              }
            , Effect.none
            )

        GetVideos ->
            ( model
            , Effect.fromCmd <| sendToBackend <| FetchVideosFromYoutube model.playlistId
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Videos for " ++ model.playlistId
    , body =
        el
            [ centerX
            , centerY
            ]
            (Element.column
                [ Element.scrollbarX ]
                [ Element.el titleStyle (Element.text <| "Videos associated to playlist:")
                , Element.el (titleStyle ++ [ Element.Font.color Styles.Colors.skyBlue ]) (Element.text <| model.playlistTitle)
                , Element.table
                    tableStyle
                    { data = model.videos |> Dict.values |> List.sortBy (.publishedAt >> strToIntTime) |> List.reverse
                    , columns =
                        [ Column (columnHeader "") (px 10) (\_ -> text "")

                        --, Column (columnHeader "Id") (px 290) (.id >> wrappedText)
                        , Column (columnHeader "Published at") (px 120) (.publishedAt >> String.left 16 >> String.right 14 >> (++) "\"" >> wrappedText)
                        , Column
                            (columnHeader "Link")
                            (px 112)
                            (\v ->
                                Element.link [ Element.Font.underline ]
                                    { url = "https://www.youtube.com/watch?v=" ++ v.id
                                    , label =
                                        Element.image
                                            [ Element.width fill
                                            , Element.height fill
                                            , Element.Border.solid
                                            , Element.Border.width 1
                                            ]
                                            { src = v.thumbnailUrl |> Maybe.withDefault "https://media1.tenor.com/m/7COT1LIbwt8AAAAC/elmo-shrug.gif"
                                            , description = "Thumbnail"
                                            }
                                    }
                                    |> wrappedCell
                            )
                        , Column (columnHeader "Channel") (px 90) (\v -> model.videoChannels |> Dict.get v.id |> Maybe.withDefault "Unknown" |> wrappedText)
                        ]
                            ++ (if model.playlistId == "*" then
                                    [ Column
                                        (columnHeader "Playlist")
                                        (px 90)
                                        (\v ->
                                            model.playlists
                                                |> Dict.get v.playlistId
                                                |> Maybe.map .title
                                                |> Maybe.withDefault "Impossubru!"
                                                |> wrappedText
                                        )
                                    ]

                                else
                                    []
                               )
                            ++ [ Column (columnHeader "Title") (px 300) (.title >> wrappedText)
                               , Column
                                    (columnHeader "Status")
                                    (px 150)
                                    (\v ->
                                        wrappedText <|
                                            case v.liveStatus of
                                                Live ->
                                                    "Live now"

                                                Ended strIme ->
                                                    "Ended at " ++ strIme

                                                Scheduled strTime ->
                                                    "Scheduled for " ++ strTime

                                                Old ->
                                                    "Old..."

                                                Uploaded ->
                                                    "Uploaded"

                                                Impossibru ->
                                                    "iMpOssIbRu!"

                                                Unknown ->
                                                    "Checking..."

                                                Expired ->
                                                    "Expired"
                                    )
                               , Column
                                    (columnHeader "Lobby")
                                    (px 75)
                                    (\v ->
                                        Api.YoutubeModel.video_viewersAtXminuteMark model.liveVideoDetails model.currentViewers 1 v.id
                                            |> Maybe.map (String.fromInt >> wrappedText)
                                            |> Maybe.withDefault (wrappedText "Unknown")
                                    )
                               , Column
                                    (columnHeader "Peak")
                                    (px 75)
                                    (\v ->
                                        model.currentViewers
                                            |> Dict.filter (\( vId, _ ) _ -> vId == v.id)
                                            |> Dict.values
                                            |> List.sortBy (.timestamp >> posixToMillis)
                                            |> List.reverse
                                            |> List.head
                                            |> Maybe.map (\cv -> cv.value |> String.fromInt |> wrappedText)
                                            |> Maybe.withDefault (wrappedText "Unknown")
                                    )
                               , Column
                                    (columnHeader "Live views")
                                    (px 90)
                                    (\v ->
                                        v.statsOnConclusion
                                            |> Maybe.map (\stats -> stats.viewCount |> String.fromInt)
                                            |> Maybe.withDefault "..."
                                            |> wrappedText
                                    )
                               , Column
                                    (columnHeader "Live Likes")
                                    (px 90)
                                    (\v ->
                                        v.statsOnConclusion
                                            |> Maybe.map (\stats -> stats.likeCount |> String.fromInt)
                                            |> Maybe.withDefault "..."
                                            |> wrappedText
                                    )
                               , Column
                                    (columnHeader "Subs gained")
                                    (px 100)
                                    (\v ->
                                        v.reportAfter24Hours
                                            |> Maybe.map (\r -> r.subscribersGained - r.subscribersLost |> String.fromInt)
                                            |> Maybe.withDefault "..."
                                            |> wrappedText
                                    )
                               , Column
                                    (columnHeader "24hr views")
                                    (px 90)
                                    (\v ->
                                        v.reportAfter24Hours
                                            |> Maybe.map (\r -> r.views |> String.fromInt)
                                            |> Maybe.withDefault "..."
                                            |> wrappedText
                                    )
                               , Column
                                    (columnHeader "Watch %")
                                    (px 90)
                                    (\v ->
                                        v.reportAfter24Hours
                                            |> Maybe.map (\r -> r.averageViewPercentage |> String.fromFloat)
                                            |> Maybe.withDefault "..."
                                            |> String.left 5
                                            |> wrappedText
                                    )

                               --    , Column
                               --         (columnHeader "Copy row")
                               --         (px 80)
                               --         (\_ ->
                               --             msgButton "Copy" (Just GetVideos)
                               --         )
                               , Column
                                    (columnHeader "Sparkline")
                                    (px 100)
                                    (\v ->
                                        model.videoStats
                                            |> Dict.filter (\_ s -> s.videoId == v.id)
                                            |> Dict.map (\_ s -> s.viewCount)
                                            |> Dict.values
                                            |> viewSparkLine
                                     -- viewSparkLine [ 30, 20, 10, 20, 15, 10, 25, 30 , 24, 18, 2, 10, 15, 16, 20, 15, 10, 5, 4, 3, 2, 1, 0, 25 ]
                                    )
                               ]
                    }
                , el
                    ([ Element.width (px 150), paddingXY 10 10 ] ++ centerCenter)
                    (msgButton "Get Videos" (Just GetVideos))
                ]
            )
    }


type alias Point =
    { x : Float, y : Float }



--viewSparkLine : List Int -> Svg.Svg msg
-- viewSparkLine dataList =
--     let
--         width = 240
--         height = 100
--         maxData = Maybe.withDefault 1 (List.maximum dataList)
--         scaledData = List.map (\n -> toFloat n / toFloat maxData * height) dataList
--         points =
--             scaledData
--                 |> List.indexedMap (\i n -> Just { x = toFloat i / 23 * width, y = height - n })
--                 |> List.filterMap identity
--     in
--     Svg.svg [ Svg.Attributes.width (String.fromInt width), Svg.Attributes.height (String.fromInt height) ]
--         [ Svg.polyline
--             [ Svg.Attributes.points <| String.join " " <| List.map (\{ x, y } -> String.fromFloat x ++ "," ++ String.fromFloat y) points
--             , Svg.Attributes.fill "none"
--             , Svg.Attributes.stroke "black"
--             , Svg.Attributes.strokeWidth "2"
--             ]
--             []
--         ] |> Element.html
-- viewSparkLine dataList =
--     let
--         width = 240
--         height = 100
--         maxData = Maybe.withDefault 1 (List.maximum dataList)
--         scaledData = List.map (\n -> toFloat n / toFloat maxData * height) dataList
--         points =
--             scaledData
--                 |> List.indexedMap (\i n -> Just { x = toFloat i / 23 * width, y = height - n })
--                 |> List.filterMap identity
--         gradientId = "rainbowGradient"
--     in
--     Svg.svg [ Svg.Attributes.width (String.fromInt width), Svg.Attributes.height (String.fromInt height) ]
--         [ Svg.defs []
--             [ Svg.linearGradient [ Svg.Attributes.id gradientId, Svg.Attributes.x1 "0%", Svg.Attributes.y1 "0%", Svg.Attributes.x2 "100%", Svg.Attributes.y2 "0%" ]
--                 [ Svg.stop [ Svg.Attributes.offset "0%", Svg.Attributes.stopColor "red" ] []
--                 , Svg.stop [ Svg.Attributes.offset "16.66%", Svg.Attributes.stopColor "orange" ] []
--                 , Svg.stop [ Svg.Attributes.offset "33.33%", Svg.Attributes.stopColor "yellow" ] []
--                 , Svg.stop [ Svg.Attributes.offset "50%", Svg.Attributes.stopColor "green" ] []
--                 , Svg.stop [ Svg.Attributes.offset "66.66%", Svg.Attributes.stopColor "blue" ] []
--                 , Svg.stop [ Svg.Attributes.offset "83.33%", Svg.Attributes.stopColor "indigo" ] []
--                 , Svg.stop [ Svg.Attributes.offset "100%", Svg.Attributes.stopColor "violet" ] []
--                 ]
--             ]
--         , Svg.polyline
--             [ Svg.Attributes.points <| String.join " " <| List.map (\{ x, y } -> String.fromFloat x ++ "," ++ String.fromFloat y) points
--             , Svg.Attributes.fill "none"
--             , Svg.Attributes.stroke ("url(#" ++ gradientId ++ ")")
--             , Svg.Attributes.strokeWidth "2"
--             ]
--             []
--         ] |> Element.html


viewSparkLine dataList =
    let
        width =
            100

        height =
            100

        maxData =
            Maybe.withDefault 1 (List.maximum dataList)

        scaledData =
            List.map (\n -> toFloat n / toFloat maxData * height) dataList

        points =
            scaledData
                |> List.indexedMap (\i n -> Just { x = toFloat i / 23 * width, y = height - n })
                |> List.filterMap identity

        gradientId =
            "rainbowGradient"

        lastPoint =
            List.head <| List.reverse points

        isDataIncomplete =
            List.length dataList < 24

        pulsatingCircle point =
            Svg.circle [ Svg.Attributes.cx (String.fromFloat point.x), Svg.Attributes.cy (String.fromFloat point.y), Svg.Attributes.r "3", Svg.Attributes.fill "green" ]
                [ Svg.animate [ Svg.Attributes.attributeName "r", Svg.Attributes.from "3", Svg.Attributes.to "6", Svg.Attributes.dur "1s", Svg.Attributes.repeatCount "indefinite" ] []
                ]
    in
    Svg.svg [ Svg.Attributes.width (String.fromInt width), Svg.Attributes.height (String.fromInt height) ]
        ([ Svg.defs []
            [ Svg.linearGradient [ Svg.Attributes.id gradientId, Svg.Attributes.x1 "0%", Svg.Attributes.y1 "0%", Svg.Attributes.x2 "100%", Svg.Attributes.y2 "0%" ]
                [ Svg.stop [ Svg.Attributes.offset "0%", Svg.Attributes.stopColor "red" ] []
                , Svg.stop [ Svg.Attributes.offset "16.66%", Svg.Attributes.stopColor "orange" ] []
                , Svg.stop [ Svg.Attributes.offset "33.33%", Svg.Attributes.stopColor "yellow" ] []
                , Svg.stop [ Svg.Attributes.offset "50%", Svg.Attributes.stopColor "green" ] []
                , Svg.stop [ Svg.Attributes.offset "66.66%", Svg.Attributes.stopColor "blue" ] []
                , Svg.stop [ Svg.Attributes.offset "83.33%", Svg.Attributes.stopColor "indigo" ] []
                , Svg.stop [ Svg.Attributes.offset "100%", Svg.Attributes.stopColor "violet" ] []
                ]
            ]
         , Svg.polyline
            [ Svg.Attributes.points <| String.join " " <| List.map (\{ x, y } -> String.fromFloat x ++ "," ++ String.fromFloat y) points
            , Svg.Attributes.fill "none"
            , Svg.Attributes.stroke ("url(#" ++ gradientId ++ ")")
            , Svg.Attributes.strokeWidth "2"
            ]
            []
         ]
            ++ (if isDataIncomplete && lastPoint /= Nothing then
                    [ pulsatingCircle (Maybe.withDefault { x = 0, y = 0 } lastPoint) ]

                else
                    []
               )
        )
        |> Element.html



-- module Main exposing (main)
-- import Svg
-- import Svg.Attributes
-- import List.Extra exposing (zip)
-- import Maybe exposing (..)
-- type alias Point =
--     { x : Float, y : Float }
-- viewSparkLine dataList =
--     let
--         padding =
--             6
--         -- Padding equal to the maximum radius of the pulsating ball
--         width =
--             240 + (2 * padding)
--         height =
--             100 + (2 * padding)
--         maxData =
--             Maybe.withDefault 1 (List.maximum dataList)
--         scaledData =
--             List.map (\n -> toFloat n / toFloat maxData * height) dataList
--         points =
--             scaledData
--                 |> List.indexedMap (\i n -> Just { x = (toFloat i / 23 * (width - 2 * padding)) + padding, y = height - padding - n })
--                 |> List.filterMap identity
--         gradientId =
--             "rainbowGradient"
--         lastPoint =
--             List.head <| List.reverse points
--         isDataIncomplete =
--             List.length dataList < 24
--         pulsatingCircle point =
--             Svg.circle [ Svg.Attributes.cx (String.fromFloat point.x), Svg.Attributes.cy (String.fromFloat point.y), Svg.Attributes.r "3", Svg.Attributes.fill "red" ]
--                 [ Svg.animate [ Svg.Attributes.attributeName "r", Svg.Attributes.from "3", Svg.Attributes.to "6", Svg.Attributes.dur "1s", Svg.Attributes.repeatCount "indefinite" ] []
--                 ]
--     in
--     Svg.svg [ Svg.Attributes.width (String.fromInt width), Svg.Attributes.height (String.fromInt height) ]
--         ([ Svg.defs []
--             [ Svg.linearGradient [ Svg.Attributes.id gradientId, Svg.Attributes.x1 "0%", Svg.Attributes.y1 "0%", Svg.Attributes.x2 "100%", Svg.Attributes.y2 "0%" ]
--                 [ Svg.stop [ Svg.Attributes.offset "0%", Svg.Attributes.stopColor "red" ] []
--                 , Svg.stop [ Svg.Attributes.offset "16.66%", Svg.Attributes.stopColor "orange" ] []
--                 , Svg.stop [ Svg.Attributes.offset "33.33%", Svg.Attributes.stopColor "yellow" ] []
--                 , Svg.stop [ Svg.Attributes.offset "50%", Svg.Attributes.stopColor "green" ] []
--                 , Svg.stop [ Svg.Attributes.offset "66.66%", Svg.Attributes.stopColor "blue" ] []
--                 , Svg.stop [ Svg.Attributes.offset "83.33%", Svg.Attributes.stopColor "indigo" ] []
--                 , Svg.stop [ Svg.Attributes.offset "100%", Svg.Attributes.stopColor "violet" ] []
--                 ]
--             ]
--          , Svg.polyline
--             [ Svg.Attributes.points <| String.join " " <| List.map (\{ x, y } -> String.fromFloat x ++ "," ++ String.fromFloat y) points
--             , Svg.Attributes.fill "none"
--             , Svg.Attributes.stroke ("url(#" ++ gradientId ++ ")")
--             , Svg.Attributes.strokeWidth "2"
--             ]
--             []
--          ]
--             ++ (if isDataIncomplete && lastPoint /= Nothing then
--                     [ pulsatingCircle (Maybe.withDefault { x = 0, y = 0 } lastPoint) ]
--                 else
--                     []
--                )
--         ) |> Element.html
