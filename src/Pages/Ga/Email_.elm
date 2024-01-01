module Pages.Ga.Email_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (Channel)
import Base64
import Bridge exposing (ToBackend(..), sendToBackend)
import Dict exposing (Dict)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border
import Element.Font exposing (underline)
import Element.Input
import Gen.Params.Ga.Email_ exposing (Params)
import Gen.Route as Route
import Html.Attributes
import Page
import Request
import Shared
import UI.Helpers exposing (..)
import Url
import View exposing (View)
import Element.Font 
import Pages.Example exposing (Msg(..))


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
    { email : String
    , channels : List Channel
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params } =
    let
        decodedEmail =
            params.email |> Base64.decode |> Result.withDefault ""
    in
    ( { email = decodedEmail
      , channels = []
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetChannels <| decodedEmail
    )



-- UPDATE


type Msg
    = GotChannels (List Channel)
    | GetChannels


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotChannels channels ->
            ( { model | channels = channels }
            , Effect.none
            )

        GetChannels ->
            ( model, Effect.fromCmd <| sendToBackend <| FetchChannelsFromYoutube <| model.email )



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
                [ Element.text model.email
                , Element.table
                    tableStyle
                    { data = model.channels
                    , columns =
                        [ Column (Element.text "Id") (px 200) (\c -> wrappedText c.id)
                        , Column (Element.text "Title") (px 275) (\c -> wrappedText c.title)
                        , Column (Element.text "Description") (px 300 |> maximum 100) (\c -> wrappedText c.description)
                        , Column (Element.text "Custom Url") (px 500) (\c -> wrappedText c.customUrl)
                        , Column
                            (Element.text "Playlists")
                            (px 200)
                            (\c -> idLink Route.Channel__Id_ c.id c.title)
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
                    { label = Element.text "Get Channels"
                    , onPress = Just GetChannels 
                    }
                ]
            )
    }
