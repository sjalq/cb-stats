module Evergreen.V51.Shared exposing (..)

import Evergreen.V51.Api.User
import Time


type alias Model =
    { viewWidth : Float
    , user : Maybe Evergreen.V51.Api.User.User
    , toastMessage : Maybe String
    }


type Msg
    = GotViewWidth Float
    | Noop
    | SignInUser Evergreen.V51.Api.User.User
    | SignOutUser
    | ShowToastMessage String
    | HideToastMessage Time.Posix
