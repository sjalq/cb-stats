module Pages.Channel.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (Channel, Playlist)
import Bridge exposing (ToBackend(..))
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border
import Element.Font exposing (..)
import Gen.Params.Channel.Id_ exposing (Params)
import Gen.Route as Route
import Html.Attributes
import Lamdera exposing (sendToBackend)
import Page
import Request
import Shared
import View exposing (View)
import UI.Helpers exposing (..)


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
    , Effect.fromCmd <| sendToBackend <| AttemptGetChannelAndPlaylists params.id
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
        el
            [ centerX
            , centerY
            ]
            (Element.column
                []
                [ Element.text <| (model.channel |> Maybe.map .title |> Maybe.withDefault "ihmpossibru!")
                , Element.table
                    tableStyle
                    { data = model.playlists
                    , columns =
                        [ Column (Element.text "Id") (px 450) (.id >> wrappedText)
                        , Column (Element.text "Title") (px 275) (.title >> wrappedText)
                        , Column (Element.text "Description") (px 400 |> maximum 100) (.description >> wrappedText)
                        ]
                    }
                ]
            )
    }
