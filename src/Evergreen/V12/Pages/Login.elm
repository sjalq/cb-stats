module Evergreen.V12.Pages.Login exposing (..)

import Evergreen.V12.Api.Data
import Evergreen.V12.Api.User


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
    | GotUser (Evergreen.V12.Api.Data.Data Evergreen.V12.Api.User.User)
