module Pages.Ga.Email_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (Channel)
import Bridge exposing (ToBackend(..), sendToBackend)
import Dict exposing (Dict)
import Effect exposing (Effect)
import Gen.Params.Ga.Email_ exposing (Params)
import Page
import Request
import Shared
import Url
import View exposing (View)
import Base64

import Element.Border
import Element exposing (..)
import Element.Font exposing (underline)
import Html.Attributes
import Gen.Route as Route


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    let
        _ =
            Debug.log "Goolgeaccount.Email_.page" "aa"
    in
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
        decodedEmail = params.email |> Base64.decode |> Result.withDefault ""
    in
    ( { email = decodedEmail
      , channels = []
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetChannels <| decodedEmail
    )



-- UPDATE


type Msg
    = GotChannels (List Channel)


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotChannels channels ->
            ( { model | channels = channels }
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
                    [ Element.text model.email
                    , Element.table
                        [ Element.centerX
                        , Element.centerY
                        , Element.spacing 5
                        , Element.padding 10
                        , Element.Border.width 1
                        ]
                        { data = model.channels
                        , columns =
                            [ { header = Element.text "Id"
                            , width = px 200
                            , view =
                                    \c ->
                                        wrappedCell c.id
                            }
                            , { header = Element.text "Title"
                            , width = px 275
                            , view =
                                    \c ->
                                        wrappedCell c.title
                            }
                            , { header = Element.text "Description"
                            , width = px 300 |> maximum 100
                            , view =
                                    \c ->
                                        wrappedCell c.description
                            }
                            , { header = Element.text "Custom Url"
                            , width = px 500
                            , view =
                                    \c ->
                                        wrappedCell c.customUrl
                            }
                            , { header = Element.text "Playlists"
                            , width = px 200
                            , view =
                                    \c ->
                                        Element.link [ centerX, centerY, underline ]
                                            { url =
                                                Route.toHref
                                                    (Route.Channel__Id_
                                                        { id = c.id 
                                                        }
                                                    )
                                            , label = Element.text "Channels"
                                            }
                            }
                            ]
                        }
                    ]
            )
    }
