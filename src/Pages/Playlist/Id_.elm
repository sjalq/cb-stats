module Pages.Playlist.Id_ exposing (Model, Msg(..), page)

import Dict
import Api.YoutubeModel exposing (Video, Playlist)
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
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params } =
    ( { videos = Dict.empty
      , playlistId = params.id 
      , playlistTitle = ""
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetVideos params.id
    )



-- UPDATE


type Msg
    = GotVideos Playlist (Dict String Video)
    | GetVideos


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotVideos playlist videos ->
            ( { model | videos = videos, playlistTitle = playlist.title }, Effect.none )

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
