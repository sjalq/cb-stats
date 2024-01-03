module Pages.Ga.Email_ exposing (Model, Msg(..), page)

import Element
import Api.YoutubeModel exposing (Channel)
import Base64
import Bridge exposing (ToBackend(..), sendToBackend)
import Dict exposing (Dict)
import Effect exposing (Effect)
import Element as ElementElement exposing (..)
import Element.Border
import Element.Font exposing (underline)
import Element.Input
import Gen.Params.Ga.Email_ exposing (Params)
import Gen.Route as Route
import Html.Attributes
import Page
import Pages.Example exposing (Msg(..))
import Request
import Shared
import UI.Helpers exposing (..)
import Url
import View exposing (View)
import Styles.Colors exposing (lightGrey)
import Styles.Colors exposing (darkGrey)


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
    { title = "Banter Stats - Channels"
    , body =
        el
            [ centerX
            , centerY
            ]
            (ElementElement.column
                []
                [ Element.el titleStyle (Element.text <| "Channels associated to")
                , Element.el (titleStyle ++ [Element.Font.color Styles.Colors.skyBlue]) (Element.text <| model.email)
                , ElementElement.table
                    tableStyle
                    { data = model.channels
                    , columns =
                        [ Column (columnHeader "Id") (px 200) (.id  >> wrappedText )
                        , Column (columnHeader "Title") (px 275) (.title >> wrappedText)
                        , Column (columnHeader "Description") (px 300 |> maximum 100) (.description >> wrappedText)
                        , Column (columnHeader "Custom Url") (px 500) (.customUrl >> wrappedText)
                        , Column 
                            (ElementElement.text "")
                            (px 200)
                            (\c ->
                                linkButton
                                    "Playlists"
                                <|
                                    Route.toHref <|
                                        Route.Channel__Id_
                                            { id = c.id }
                            )
                        ]
                    }
                , el ([ ElementElement.width (px 200), paddingXY 10 10 ] ++ centerCenter) <| msgButton "Get Channels" <| Just GetChannels
                ]
            )
    }
