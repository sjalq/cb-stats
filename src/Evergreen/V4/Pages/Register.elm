module Evergreen.V4.Pages.Register exposing (..)

import Evergreen.V4.Api.Data
import Evergreen.V4.Api.User


type alias Model =
    { email : String
    , password : String
    , errorMessage : Maybe String
    , showPassword : Bool
    }


type Field
    = Email
    | Password


type Msg
    = Updated Field String
    | ToggledShowPassword
    | ClickedSubmit
    | GotUser (Evergreen.V4.Api.Data.Data Evergreen.V4.Api.User.User)
