module Evergreen.V37.Shared exposing (..)

import Evergreen.V37.Api.User
import Time


type alias Model =
    { viewWidth : Float
    , user : Maybe Evergreen.V37.Api.User.User
    , toastMessage : Maybe String
    }


type Msg
    = GotViewWidth Float
    | Noop
    | SignInUser Evergreen.V37.Api.User.User
    | SignOutUser
    | ShowToastMessage String
    | HideToastMessage Time.Posix
