module Pages.Playlist.Id_ exposing (Model, Msg(..), page)

import Api.PerformNow exposing (performNowWithTime)
import Api.YoutubeModel exposing (CurrentViewers, LiveStatus(..), LiveVideoDetails, Playlist, Video, video_liveViewsEstimate, video_peakViewers)
import Bridge exposing (..)
import Dict exposing (Dict)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Background
import Element.Border
import Element.Font
import Element.Input
import Gen.Params.Playlist.Id_ exposing (Params)
import Gen.Route as Route
import Html exposing (label)
import Maybe exposing (withDefault)
import MoreDict
import Page
import Request
import Shared
import Styles.Colors
import Svg
import Svg.Attributes
import Time exposing (posixToMillis)
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
    { playlistId : String
    , playlistTitle : String
    , videos : Dict String Video
    , liveVideoDetails : Dict String LiveVideoDetails
    , currentViewers : Dict ( String, Int ) CurrentViewers
    , videoChannels : Dict String String
    , playlists : Dict String Playlist
    , videoStats : Dict ( String, Int ) Api.YoutubeModel.VideoStatisticsAtTime
    , competitorVideos : Dict String (Dict String Video)
    , currentIntTime : Int
    , tmpCtrs : Dict String String
    , tmpLiveViews : Dict String String
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
      , competitorVideos = Dict.empty
      , currentIntTime = 0
      , tmpCtrs = Dict.empty
      , tmpLiveViews = Dict.empty
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetVideos params.id
    )



-- UPDATE


type Msg
    = GotVideos Api.YoutubeModel.VideoResults
    | GetVideos
    | UpdateVideoCTR String String
    | UpdateVideoLiveViews String String
    | Tick Time.Posix


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotVideos results ->
            ( { model
                | videos = results.videos
                , playlistTitle =
                    if Dict.size results.playlists == 1 then
                        results.playlists |> Dict.values |> List.head |> Maybe.map .title |> Maybe.withDefault "Unknown"

                    else
                        "All monitored playlists"
                , liveVideoDetails = results.liveVideoDetails
                , currentViewers = results.currentViewers
                , videoChannels = results.videoChannels
                , playlists = results.playlists
                , videoStats = results.videoStats
                , competitorVideos = results.competitorVideos |> Debug.log "competitorVideos"
                , tmpCtrs = results.videos |> Dict.map (\_ v -> v.ctr |> Maybe.map String.fromFloat |> Maybe.withDefault "")
                , tmpLiveViews = results.videos |> Dict.map (\_ v -> v.liveViews |> Maybe.map String.fromInt |> Maybe.withDefault "")
              }
            , Effect.none
            )

        GetVideos ->
            ( model
            , Effect.fromCmd <| sendToBackend <| FetchVideosFromYoutube model.playlistId
            )

        Tick time ->
            ( { model | currentIntTime = time |> posixToMillis }
            , Effect.none
            )

        UpdateVideoCTR id ctr ->
            let
                ctrFloat =
                    ctr
                        |> String.left 6
                        |> String.toFloat
            in
            case ctrFloat of
                Just ctrFloat_ ->
                    if (ctrFloat_ >= 0 && ctrFloat_ <= 100) && ((ctr |> String.length) <= 5) then
                        ( { model | tmpCtrs = Dict.insert id ctr model.tmpCtrs }
                        , Effect.fromCmd <| sendToBackend <| AttemptUpdateVideoCtr id ctrFloat
                        )

                    else
                        ( model, Effect.none )

                Nothing ->
                    if ctr == "" then
                        ( { model | tmpCtrs = Dict.insert id ctr model.tmpCtrs }
                        , Effect.fromCmd <| sendToBackend <| AttemptUpdateVideoCtr id Nothing
                        )

                    else
                        ( model, Effect.none )

        UpdateVideoLiveViews id liveViews ->
            let
                liveViewsInt =
                    liveViews
                        |> String.toInt
            in
            case liveViewsInt of
                Just liveViewsInt_ ->
                    if liveViewsInt_ >= 0 then
                        ( { model | tmpLiveViews = Dict.insert id liveViews model.tmpLiveViews }
                        , Effect.fromCmd <| sendToBackend <| AttemptUpdateVideoLiveViews id liveViewsInt
                        )

                    else
                        ( model, Effect.none )

                Nothing ->
                    if liveViews == "" then
                        ( { model | tmpLiveViews = Dict.insert id liveViews model.tmpLiveViews }
                        , Effect.fromCmd <| sendToBackend <| AttemptUpdateVideoLiveViews id Nothing
                        )

                    else
                        ( model, Effect.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch [ Time.every second Tick ]



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
                            ++ [ Column (columnHeader "Title") (px 200) (.title >> wrappedText)
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
                                        Api.YoutubeModel.video_lobbyEstimate model.liveVideoDetails model.currentViewers v.id
                                            |> Maybe.map (String.fromInt >> wrappedText)
                                            |> Maybe.withDefault (wrappedText "Unknown")
                                    )
                               , Column
                                    (columnHeader "Peak")
                                    (px 75)
                                    (\v ->
                                        video_peakViewers model.currentViewers v.id
                                            |> Maybe.map (String.fromInt >> wrappedText)
                                            |> Maybe.withDefault (wrappedText "Unknown")
                                    )
                               , Column
                                    (columnHeader "Live views±")
                                    (px 95)
                                    (\v ->
                                        video_liveViewsEstimate v model.currentViewers
                                            |> Maybe.map String.fromInt
                                            |> Maybe.withDefault "..."
                                            |> wrappedText
                                    )
                               , Column
                                    (columnHeader "Live views")
                                    (px 90)
                                    (\v ->
                                        Element.Input.multiline
                                            [ height fill, paddingXY 3 3, Element.Font.size 17, Element.Background.color (rgb 0.95 0.95 1) ]
                                            { onChange = UpdateVideoLiveViews v.id
                                            , text = model.tmpLiveViews |> Dict.get v.id |> Maybe.withDefault ""
                                            , placeholder = Nothing
                                            , label = Element.Input.labelHidden "Live views"
                                            , spellcheck = False
                                            }
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
                                    (columnHeader "24hr views")
                                    (px 90)
                                    (\v ->
                                        let
                                            stats =
                                                model.videoStats
                                                    |> Dict.filter (\_ s -> s.videoId == v.id)
                                                    |> Dict.map (\_ s -> s.viewCount)
                                                    |> Dict.values

                                            stillFetching =
                                                case v.liveStatus of
                                                    Ended strTime ->
                                                        strToIntTime strTime + day > model.currentIntTime

                                                    Uploaded ->
                                                        strToIntTime v.publishedAt + day > model.currentIntTime

                                                    _ ->
                                                        False

                                            max =
                                                stats
                                                    |> List.maximum
                                                    |> Maybe.map String.fromInt
                                                    |> Maybe.withDefault ""
                                        in
                                        if stillFetching then
                                            wrappedText "..."

                                        else
                                            wrappedText max
                                     -- v.statsAfter24Hours
                                     --     |> Maybe.map (\r -> r.viewCount |> String.fromInt)
                                     --     |> Maybe.withDefault "..."
                                     --     |> wrappedText
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
                                    (columnHeader "Watch %")
                                    (px 90)
                                    (\v ->
                                        v.reportAfter24Hours
                                            |> Maybe.map (\r -> r.averageViewPercentage |> String.fromFloat)
                                            |> Maybe.withDefault "..."
                                            |> String.left 5
                                            |> wrappedText
                                    )
                               , Column
                                    (columnHeader "CTR")
                                    (px 90)
                                    (\v ->
                                        Element.Input.multiline
                                            [ height fill, paddingXY 3 3, Element.Font.size 17, Element.Background.color (rgb 0.95 0.95 1) ]
                                            { onChange = UpdateVideoCTR v.id
                                            , text = model.tmpCtrs |> Dict.get v.id |> Maybe.withDefault ""
                                            , placeholder = Nothing
                                            , label = Element.Input.labelHidden "CTR"
                                            , spellcheck = False
                                            }
                                    )
                               ]
                            ++ competitorVideoColums model.competitorVideos get24HrCompetitorStats
                            ++ [ Column
                                    (columnHeader "Details")
                                    (px 90)
                                    (\v ->
                                        linkButton
                                            "Details"
                                        <|
                                            Route.toHref <|
                                                Route.Video__Id_
                                                    { id = v.id }
                                    )

                               --    , Column
                               --         (columnHeader "Sparkline")
                               --         (px 100)
                               --         (\v ->
                               --             model.videoStats
                               --                 |> Dict.filter (\_ s -> s.videoId == v.id)
                               --                 |> Dict.map (\_ s -> s.viewCount)
                               --                 |> Dict.values
                               --                 |> viewSparkLine
                               --          -- viewSparkLine [ 30, 20, 10, 20, 15, 10, 25, 30 , 24, 18, 2, 10, 15, 16, 20, 15, 10, 5, 4, 3, 2, 1, 0, 25 ]
                               --         )
                               ]
                    }
                , el
                    ([ Element.width (px 150), paddingXY 10 10 ] ++ centerCenter)
                    (msgButton "Get Videos" (Just GetVideos))
                ]
            )
    }


get24HrCompetitorStats : Dict String (Dict String Video) -> String -> Video -> Element Msg
get24HrCompetitorStats competitorVideos competitorChannelTitle ourVideo =
    competitorVideos
        |> Dict.get ourVideo.id
        |> Debug.log "finding v.id"
        |> Maybe.map
            (\competitorsVideosForOurVideo ->
                let
                    our24HrViews =
                        ourVideo.statsAfter24Hours
                            |> Maybe.map .viewCount

                    firstCompetitorVideo = 
                        competitorsVideosForOurVideo
                            |> Dict.filter (\k v_ -> v_.videoOwnerChannelTitle == competitorChannelTitle)
                            |> Dict.values
                            |> List.head

                    competitor24HrViews =
                        firstCompetitorVideo
                            |> Maybe.andThen .statsAfter24Hours
                            |> Maybe.map .viewCount
                            |> Debug.log "competitor24HrViews"

                    percentageBetterThanThem =
                        Maybe.map2
                            (\ourViews theirViews ->
                                case ( ourViews, theirViews ) of
                                    ( _, 0 ) ->
                                        10000

                                    _ ->
                                        (toFloat ourViews / toFloat theirViews - 1) * 100
                            )
                            our24HrViews
                            competitor24HrViews

                    betterThanThemColor =
                        percentageBetterThanThem
                            |> Maybe.map
                                (\percentageBetterThanThem_ ->
                                    let
                                        positiveOffset =
                                            -(percentageBetterThanThem_ / 300 * 255) |> max 255 |> min 0

                                        negativeOffset =
                                            -(1 - percentageBetterThanThem_ / 100 * 255) |> max 255 |> min 0
                                    in
                                    if percentageBetterThanThem_ >= 0 then
                                        rgb positiveOffset 255 positiveOffset

                                    else
                                        rgb 255 negativeOffset negativeOffset
                                )

                    percentageBetterThanThemStr =
                        percentageBetterThanThem
                            |> Maybe.map
                                (\percentageBetterThanThem_ ->
                                    if percentageBetterThanThem_ >= 10000 then
                                        "∞%"

                                    else
                                        (String.fromFloat percentageBetterThanThem_ |> String.left 5) ++ "%"
                                )
                in
                -- percentageBetterThanThemStr
                --     |> Maybe.withDefault "..."
                --     |> wrappedText
                firstCompetitorVideo 
                    |> Maybe.map .title 
                    |> Maybe.withDefault "???"
                    |> wrappedText
             --|> el [ Element.Background.color betterThanThemColor ]
            )
        |> Maybe.withDefault (wrappedText "...")


competitorVideoColums : Dict String (Dict String Video) -> (Dict String (Dict String Video) -> String -> Video -> Element Msg) -> List (Column Video Msg)
competitorVideoColums competitorVideos vFunc =
    competitorVideos
        |> Debug.log "competitorVideoss"
        |> Dict.values
        |> List.map Dict.values
        |> List.concat
        -- |> MoreDict.groupBy .videoOwnerChannelTitle
        -- |> Dict.map
        --     (\k v ->
        --         ( k
        --         , v
        --             |> List.map .id
        --             |> Debug.log "ids"
        --             |> List.head
        --             |> Maybe.withDefault ""
        --         )
        --     )
        -- |> Dict.values
        -- |> List.map
        --     (\( title, id ) ->
        --         Column
        --             (columnHeader title)
        --             (px 100)
        --             (vFunc competitorVideos id)
        --     )
        |> MoreDict.groupBy .videoOwnerChannelTitle
        |> Dict.keys
        |> List.map
            (\title ->
                Column
                    (columnHeader title)
                    (px 100)
                    (vFunc competitorVideos title)
            )


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
