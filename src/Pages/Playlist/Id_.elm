module Pages.Playlist.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel
import Effect exposing (Effect)
import Gen.Params.Playlist.Id_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Api.YoutubeModel exposing (Video)
import Element exposing (..)
import UI.Helpers exposing (..)
import Element.Font
import Element.Border
import Element.Input
import Bridge exposing (..)
import Dict exposing (Dict)


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
    , videos : Dict String Video
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params }=
    ( { videos = Dict.empty
    , playlistId = params.id }
    , Effect.fromCmd <| sendToBackend <| AttemptGetVideos params.id )



-- UPDATE


type Msg
    = GotVideos (Dict String Video)
    | GetVideos


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotVideos videos ->
            ( { model | videos = videos }, Effect.none )
        GetVideos ->
            ( model
            , Effect.fromCmd <| sendToBackend <| FetchVideosFromYoutube model.playlistId )
        



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
                [ Element.text <| (model.playlistId )
                , Element.table
                    tableStyle
                    { data = model.videos |> Dict.values
                    , columns =
                        [ Column (columnHeader "Id") (px 200) (.id >> wrappedText)
                        , Column (columnHeader "Title") (px 275) (.title >> wrappedText)
                        , Column (columnHeader "Description") (px 400 |> maximum 100) (.description >> wrappedText)
                        , Column (columnHeader "Published at") (px 220) (.publishedAt >> wrappedText)
                        , Column (columnHeader "Duration") (px 100) (.duration >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Views") (px 100) (.viewCount >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Likes") (px 100) (.likeCount >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Dislikes") (px 100) (.dislikeCount >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Favorites") (px 100) (.favoriteCount >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Comments") (px 100) (.commentCount >> String.fromInt >> wrappedText)
                        ]
                    }
                , el
                    ([ Element.width (px 200), paddingXY 10 10 ] ++ centerCenter) 
                    (msgButton "Get Videos" (Just GetVideos))
                ]
            )
    }
