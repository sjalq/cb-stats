module Pages.Playlist.Id_ exposing (Model, Msg(..), page)

import Api.Time exposing (..)
import Api.YoutubeModel exposing (CurrentViewers, LiveStatus(..), LiveVideoDetails, Playlist, Video)
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

    --, videoStats : Dict String Api.YoutubeModel.VideoStats
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

      --, videoStats = Dict.empty
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetVideos params.id
    )



-- UPDATE


type Msg
    = GotVideos (Dict String Playlist) (Dict String Video) (Dict String LiveVideoDetails) (Dict ( String, Int ) CurrentViewers) (Dict String String)
    | GetVideos


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotVideos playlists videos liveVideoDetails currentViewers videoChannels ->
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
                                    , label =  Element.image
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
                                            |> wrappedText ) ]

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

                                                Expired ->
                                                    "Schedule expired"

                                                Uploaded ->
                                                    "Uploaded"

                                                Impossibru ->
                                                    "iMpOssIbRu!"

                                                Unknown ->
                                                    "Checking..."
                                    )
                               , Column
                                    (columnHeader "Lobby")
                                    (px 75)
                                    (\v ->
                                        Api.YoutubeModel.video_viewersAtXminuteMark model.liveVideoDetails model.currentViewers 3 v.id
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
                               , Column
                                    (columnHeader "Copy row")
                                    (px 80)
                                    (\_ ->
                                        msgButton "Copy" (Just GetVideos)
                                    )

                               -- , Columns
                               ]
                    }
                , el
                    ([ Element.width (px 150), paddingXY 10 10 ] ++ centerCenter)
                    (msgButton "Get Videos" (Just GetVideos))
                ]
            )
    }
