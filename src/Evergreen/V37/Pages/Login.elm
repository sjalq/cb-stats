module Evergreen.V37.Pages.Login exposing (..)

import Evergreen.V37.Api.Data
import Evergreen.V37.Api.User


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
    | GotUser (Evergreen.V37.Api.Data.Data Evergreen.V37.Api.User.User)
