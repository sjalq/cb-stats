module Pages.Video.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (..)
import Bridge exposing (ToBackend(..))
import Effect exposing (Effect)
import Element exposing (..)
import Gen.Params.Video.Id_ exposing (Params)
import Iso8601
import Lamdera exposing (sendToBackend)
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


draw24HourViews : List VideoStatisticsAtTime -> Element msg
draw24HourViews videoStatisticsAtTime =
    Element.table []
        { data = videoStatisticsAtTime
        , columns =
            [ Column (text "Time") (px 300) (.timestamp >> Iso8601.fromTime >> Element.text)
            , Column (text "Views") (px 100)  (.viewCount >> String.fromInt >> Element.text)
            , Column (text "Likes") (px 100)  (.likeCount >> String.fromInt >> Element.text)
            , Column (text "Dislikes") (px 100)  (.dislikeCount >> Maybe.map String.fromInt >> Maybe.withDefault "" >> Element.text)
            , Column (text "Comments") (px 100)  (.commentCount >> Maybe.map String.fromInt >> Maybe.withDefault "" >> Element.text)
            ]
        }

drawLiveViewers : List CurrentViewers -> Element msg
drawLiveViewers currentViewers =
    Element.table []
        { data = currentViewers
        , columns =
            [ Column (text "Time") (px 300) (.timestamp >> Iso8601.fromTime >> Element.text)
            , Column (text "Viewers") (px 100)  (.value >> String.fromInt >> Element.text)
            ]
        }


view : Model -> View Msg
view model =
    { title = "Video"
    , body =
        column [ width <| px 300 ]
            [ drawField "Title" <| Maybe.withDefault "" <| Maybe.map .title model.video
            , drawField "Description" <| Maybe.withDefault "" <| Maybe.map .description model.video
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
