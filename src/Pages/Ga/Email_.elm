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
    View.placeholder model.email
