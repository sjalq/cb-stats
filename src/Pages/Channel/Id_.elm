module Pages.Channel.Id_ exposing (Model, Msg, page)

import Api.YoutubeModel exposing (Channel, Playlist)
import Effect exposing (Effect)
import Gen.Params.Channel.Id_ exposing (Params)
import Page
import Request
import Shared
import View exposing (View)
import Element exposing (..)
import Element.Border
import Html.Attributes
import Element.Font exposing (..)
import Gen.Route as Route

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
    { channelId : String
    , channel : Maybe Channel
    , playlists : List Playlist
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params } =
    ( { channelId = params.id
      , channel = Nothing
      , playlists = []
      }
    , Effect.none
    )



-- UPDATE


type Msg
    = GotChannelAndPlaylists Channel (List Playlist)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotChannelAndPlaylists channel playlists ->
            ( { model | channel = Just channel, playlists = playlists }
            , Effect.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    { title = "Elm Land ❤️ Lamdera"
    , body =
        let
            wrappedCell text =
                Element.paragraph
                    [ Element.width <| Element.px 200
                    , Element.Border.width 1
                    , Element.htmlAttribute (Html.Attributes.style "marginLeft" "auto")
                    , Element.htmlAttribute (Html.Attributes.style "marginRight" "auto")
                    ]
                    [ Element.text text ]
        in
            el
                [ centerX
                , centerY
                ]
                (Element.column
                    []
                    [ Element.text <| (model.channel |> Maybe.map .title |> Maybe.withDefault "ihmpossibru!")
                    , Element.table
                        [ Element.centerX
                        , Element.centerY
                        , Element.spacing 5
                        , Element.padding 10
                        , Element.Border.width 1
                        ]
                        { data = model.playlists
                        , columns =
                            [ { header = Element.text "Id"
                            , width = px 200
                            , view =
                                    \p ->
                                        wrappedCell p.id
                            }
                            , { header = Element.text "Title"
                            , width = px 275
                            , view =
                                    \p ->
                                        wrappedCell p.title
                            }
                            , { header = Element.text "Description"
                            , width = px 300 |> maximum 100
                            , view =
                                    \p ->
                                        wrappedCell p.description

                            }
                            ]
                        }
                    ]
                )
    }