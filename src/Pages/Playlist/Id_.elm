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
                        [ Column (columnHeader "Id") (px 450) (.id >> wrappedText)
                        , Column (columnHeader "Title") (px 275) (.title >> wrappedText)
                        , Column (columnHeader "Description") (px 400 |> maximum 100) (.description >> wrappedText)
                        , Column (columnHeader "Published at") (px 200) (.publishedAt >> wrappedText)
                        , Column (columnHeader "Duration") (px 100) (.duration >> String.fromInt >> wrappedText)
                        , Column (columnHeader "View count") (px 100) (.viewCount >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Like count") (px 100) (.likeCount >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Dislike count") (px 100) (.dislikeCount >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Favorite count") (px 100) (.favoriteCount >> String.fromInt >> wrappedText)
                        , Column (columnHeader "Comment count") (px 100) (.commentCount >> String.fromInt >> wrappedText)
                        ]
                    }
                , Element.Input.button
                    [ centerX
                    , centerY
                    , Element.Font.size 16
                    , Element.Font.bold
                    , padding 30
                    , Element.Border.color <| rgb255 128 128 128
                    , Element.Border.width 1
                    , Element.Border.innerGlow (rgb255 128 0 0) 5
                    --, Element.Border.glow (rgb255 128 0 0) 10
                    --, Element.Border.shadow { offset = (10, 10), size = 3, blur = 0.5, color = rgb255 128 0 0 }
                    --, border3d 4 Color.grey Color.black Color.white
                    --, Element.Border.color (rgb255 0 128 128) -- Typical teal color
                    --, hover [ Background.color (rgb255 0 104 104) ] -- Slightly darker on hover
                    ]
                    { label = Element.text "Get Videos"
                    , onPress = Just GetVideos
                    }
                , msgButton "Get Videos" (Just GetVideos)
                ]
            )
    }
