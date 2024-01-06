module Pages.Playlist.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (CurrentViewers, LiveStatus(..), LiveVideoDetails, Playlist, Video)
import Bridge exposing (..)
import Dict exposing (Dict)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border
import Element.Font
import Element.Input
import Gen.Params.Playlist.Id_ exposing (Params)
import Page
import Request
import Shared
import Styles.Colors
import Time exposing (Posix)
import UI.Helpers exposing (..)
import View exposing (View)
import Time exposing (posixToMillis)


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
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params } =
    ( { videos = Dict.empty
      , playlistId = params.id
      , playlistTitle = ""
      , liveVideoDetails = Dict.empty
      , currentViewers = Dict.empty
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetVideos params.id
    )



-- UPDATE


type Msg
    = GotVideos Playlist (Dict String Video) (Dict String LiveVideoDetails) (Dict ( String, Int ) CurrentViewers)
    | GetVideos


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotVideos playlist videos liveVideoDetails currentViewers ->
            ( { model
                | videos = videos
                , playlistTitle = playlist.title
                , liveVideoDetails = liveVideoDetails
                , currentViewers = currentViewers
              }
            , Effect.none
            )

        GetVideos ->
            ( model
            , Effect.fromCmd <| sendToBackend <| FetchVideosFromYoutube model.playlistId
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
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
                []
                [ Element.el titleStyle (Element.text <| "Videos associated to playlist:")
                , Element.el (titleStyle ++ [ Element.Font.color Styles.Colors.skyBlue ]) (Element.text <| model.playlistTitle)
                , Element.table
                    tableStyle
                    { data = model.videos |> Dict.values
                    , columns =
                        [ Column (columnHeader "Id") (px 200) (.id >> wrappedText)
                        , Column (columnHeader "Title") (px 275) (.title >> wrappedText)
                        , Column (columnHeader "Description") (px 400 |> maximum 100) (.description >> wrappedText)
                        , Column (columnHeader "Published at") (px 220) (.publishedAt >> wrappedText)
                        , Column
                            (columnHeader "Channel")
                            (px 200)
                            (\v ->
                                wrappedText <|
                                    case v.liveStatus of
                                        Live ->
                                            "Live now"

                                        Ended ->
                                            "Ended"

                                        Scheduled strTime ->
                                            "Scheduled for " ++ strTime 

                                        Expired ->
                                            "Schedule expired"

                                        NeverLive ->
                                            "Uploaded"

                                        Impossibru ->
                                            "iMpOssIbRu!"

                                        Unknown ->
                                            "Unknown - checking..."
                            )
                        , Column
                            (columnHeader "Current")
                            (px 100)
                            (\v -> 
                                model.currentViewers
                                    |> Dict.filter (\(vId, time) cv  -> vId == v.id)
                                    |> Dict.values
                                    |> List.sortBy (.timestamp >> posixToMillis)
                                    |> List.reverse
                                    |> List.head
                                    |> Maybe.map (\cv -> cv.value |> String.fromInt |> wrappedText)
                                    |> Maybe.withDefault (wrappedText "Unknown")
                            )
                        , Column 
                            (columnHeader "Peak")
                            (px 100)
                            (\v -> 
                                model.currentViewers
                                    |> Dict.filter (\(vId, time) cv  -> vId == v.id)
                                    |> Dict.values
                                    |> List.map (\cv -> cv.value)
                                    |> List.maximum 
                                    |> Maybe.map (\cv -> cv  |> String.fromInt |> wrappedText)
                                    |> Maybe.withDefault (wrappedText "Unknown")
                            )

                        ]
                    }
                , el
                    ([ Element.width (px 200), paddingXY 10 10 ] ++ centerCenter)
                    (msgButton "Get Videos" (Just GetVideos))
                ]
            )
    }
