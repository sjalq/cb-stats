module Evergreen.V4.Pages.Login exposing (..)

import Evergreen.V4.Api.Data
import Evergreen.V4.Api.User


type alias Model =
    { email : String
    , password : String
    , showPassword : Bool
    , errorMessage : Maybe String
    }


type Field
    = Email
    | Password


type Msg
    = Updated Field String
    | ToggledShowPassword
    | ClickedSubmit
    | GotUser (Evergreen.V4.Api.Data.Data Evergreen.V4.Api.User.User)
