module Evergreen.V40.Shared exposing (..)

import Evergreen.V40.Api.User
import Time


type alias Model =
    { viewWidth : Float
    , user : Maybe Evergreen.V40.Api.User.User
    , toastMessage : Maybe String
    }


type Msg
    = GotViewWidth Float
    | Noop
    | SignInUser Evergreen.V40.Api.User.User
    | SignOutUser
    | ShowToastMessage String
    | HideToastMessage Time.Posix
