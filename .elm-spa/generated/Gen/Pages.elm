module Gen.Pages exposing (Model, Msg, init, subscriptions, update, view)

import Browser.Navigation exposing (Key)
import Effect exposing (Effect)
import ElmSpa.Page
import Gen.Params.Admin
import Gen.Params.End
import Gen.Params.Example
import Gen.Params.Home_
import Gen.Params.Log
import Gen.Params.Login
import Gen.Params.NotFound
import Gen.Params.Register
import Gen.Params.Channel.Id_
import Gen.Params.Ga.Email_
import Gen.Params.Playlist.Id_
import Gen.Params.Video.Id_
import Gen.Model as Model
import Gen.Msg as Msg
import Gen.Route as Route exposing (Route)
import Page exposing (Page)
import Pages.Admin
import Pages.End
import Pages.Example
import Pages.Home_
import Pages.Log
import Pages.Login
import Pages.NotFound
import Pages.Register
import Pages.Channel.Id_
import Pages.Ga.Email_
import Pages.Playlist.Id_
import Pages.Video.Id_
import Request exposing (Request)
import Shared
import Task
import Url exposing (Url)
import View exposing (View)


type alias Model =
    Model.Model


type alias Msg =
    Msg.Msg


init : Route -> Shared.Model -> Url -> Key -> ( Model, Effect Msg )
init route =
    case route of
        Route.Admin ->
            pages.admin.init ()
    
        Route.End ->
            pages.end.init ()
    
        Route.Example ->
            pages.example.init ()
    
        Route.Home_ ->
            pages.home_.init ()
    
        Route.Log ->
            pages.log.init ()
    
        Route.Login ->
            pages.login.init ()
    
        Route.NotFound ->
            pages.notFound.init ()
    
        Route.Register ->
            pages.register.init ()
    
        Route.Channel__Id_ params ->
            pages.channel__id_.init params
    
        Route.Ga__Email_ params ->
            pages.ga__email_.init params
    
        Route.Playlist__Id_ params ->
            pages.playlist__id_.init params
    
        Route.Video__Id_ params ->
            pages.video__id_.init params


update : Msg -> Model -> Shared.Model -> Url -> Key -> ( Model, Effect Msg )
update msg_ model_ =
    case ( msg_, model_ ) of
        ( Msg.Admin msg, Model.Admin params model ) ->
            pages.admin.update params msg model
    
        ( Msg.End msg, Model.End params model ) ->
            pages.end.update params msg model
    
        ( Msg.Example msg, Model.Example params model ) ->
            pages.example.update params msg model
    
        ( Msg.Home_ msg, Model.Home_ params model ) ->
            pages.home_.update params msg model
    
        ( Msg.Log msg, Model.Log params model ) ->
            pages.log.update params msg model
    
        ( Msg.Login msg, Model.Login params model ) ->
            pages.login.update params msg model
    
        ( Msg.Register msg, Model.Register params model ) ->
            pages.register.update params msg model
    
        ( Msg.Channel__Id_ msg, Model.Channel__Id_ params model ) ->
            pages.channel__id_.update params msg model
    
        ( Msg.Ga__Email_ msg, Model.Ga__Email_ params model ) ->
            pages.ga__email_.update params msg model
    
        ( Msg.Playlist__Id_ msg, Model.Playlist__Id_ params model ) ->
            pages.playlist__id_.update params msg model
    
        ( Msg.Video__Id_ msg, Model.Video__Id_ params model ) ->
            pages.video__id_.update params msg model

        _ ->
            \_ _ _ -> ( model_, Effect.none )


view : Model -> Shared.Model -> Url -> Key -> View Msg
view model_ =
    case model_ of
        Model.Redirecting_ ->
            \_ _ _ -> View.none
    
        Model.Admin params model ->
            pages.admin.view params model
    
        Model.End params model ->
            pages.end.view params model
    
        Model.Example params model ->
            pages.example.view params model
    
        Model.Home_ params model ->
            pages.home_.view params model
    
        Model.Log params model ->
            pages.log.view params model
    
        Model.Login params model ->
            pages.login.view params model
    
        Model.NotFound params ->
            pages.notFound.view params ()
    
        Model.Register params model ->
            pages.register.view params model
    
        Model.Channel__Id_ params model ->
            pages.channel__id_.view params model
    
        Model.Ga__Email_ params model ->
            pages.ga__email_.view params model
    
        Model.Playlist__Id_ params model ->
            pages.playlist__id_.view params model
    
        Model.Video__Id_ params model ->
            pages.video__id_.view params model


subscriptions : Model -> Shared.Model -> Url -> Key -> Sub Msg
subscriptions model_ =
    case model_ of
        Model.Redirecting_ ->
            \_ _ _ -> Sub.none
    
        Model.Admin params model ->
            pages.admin.subscriptions params model
    
        Model.End params model ->
            pages.end.subscriptions params model
    
        Model.Example params model ->
            pages.example.subscriptions params model
    
        Model.Home_ params model ->
            pages.home_.subscriptions params model
    
        Model.Log params model ->
            pages.log.subscriptions params model
    
        Model.Login params model ->
            pages.login.subscriptions params model
    
        Model.NotFound params ->
            pages.notFound.subscriptions params ()
    
        Model.Register params model ->
            pages.register.subscriptions params model
    
        Model.Channel__Id_ params model ->
            pages.channel__id_.subscriptions params model
    
        Model.Ga__Email_ params model ->
            pages.ga__email_.subscriptions params model
    
        Model.Playlist__Id_ params model ->
            pages.playlist__id_.subscriptions params model
    
        Model.Video__Id_ params model ->
            pages.video__id_.subscriptions params model



-- INTERNALS


pages :
    { admin : Bundle Gen.Params.Admin.Params Pages.Admin.Model Pages.Admin.Msg
    , end : Bundle Gen.Params.End.Params Pages.End.Model Pages.End.Msg
    , example : Bundle Gen.Params.Example.Params Pages.Example.Model Pages.Example.Msg
    , home_ : Bundle Gen.Params.Home_.Params Pages.Home_.Model Pages.Home_.Msg
    , log : Bundle Gen.Params.Log.Params Pages.Log.Model Pages.Log.Msg
    , login : Bundle Gen.Params.Login.Params Pages.Login.Model Pages.Login.Msg
    , notFound : Static Gen.Params.NotFound.Params
    , register : Bundle Gen.Params.Register.Params Pages.Register.Model Pages.Register.Msg
    , channel__id_ : Bundle Gen.Params.Channel.Id_.Params Pages.Channel.Id_.Model Pages.Channel.Id_.Msg
    , ga__email_ : Bundle Gen.Params.Ga.Email_.Params Pages.Ga.Email_.Model Pages.Ga.Email_.Msg
    , playlist__id_ : Bundle Gen.Params.Playlist.Id_.Params Pages.Playlist.Id_.Model Pages.Playlist.Id_.Msg
    , video__id_ : Bundle Gen.Params.Video.Id_.Params Pages.Video.Id_.Model Pages.Video.Id_.Msg
    }
pages =
    { admin = bundle Pages.Admin.page Model.Admin Msg.Admin
    , end = bundle Pages.End.page Model.End Msg.End
    , example = bundle Pages.Example.page Model.Example Msg.Example
    , home_ = bundle Pages.Home_.page Model.Home_ Msg.Home_
    , log = bundle Pages.Log.page Model.Log Msg.Log
    , login = bundle Pages.Login.page Model.Login Msg.Login
    , notFound = static Pages.NotFound.view Model.NotFound
    , register = bundle Pages.Register.page Model.Register Msg.Register
    , channel__id_ = bundle Pages.Channel.Id_.page Model.Channel__Id_ Msg.Channel__Id_
    , ga__email_ = bundle Pages.Ga.Email_.page Model.Ga__Email_ Msg.Ga__Email_
    , playlist__id_ = bundle Pages.Playlist.Id_.page Model.Playlist__Id_ Msg.Playlist__Id_
    , video__id_ = bundle Pages.Video.Id_.page Model.Video__Id_ Msg.Video__Id_
    }


type alias Bundle params model msg =
    ElmSpa.Page.Bundle params model msg Shared.Model (Effect Msg) Model Msg (View Msg)


bundle page toModel toMsg =
    ElmSpa.Page.bundle
        { redirecting =
            { model = Model.Redirecting_
            , view = View.none
            }
        , toRoute = Route.fromUrl
        , toUrl = Route.toHref
        , fromCmd = Effect.fromCmd
        , mapEffect = Effect.map toMsg
        , mapView = View.map toMsg
        , toModel = toModel
        , toMsg = toMsg
        , page = page
        }


type alias Static params =
    Bundle params () Never


static : View Never -> (params -> Model) -> Static params
static view_ toModel =
    { init = \params _ _ _ -> ( toModel params, Effect.none )
    , update = \params _ _ _ _ _ -> ( toModel params, Effect.none )
    , view = \_ _ _ _ _ -> View.map never view_
    , subscriptions = \_ _ _ _ _ -> Sub.none
    }
    
