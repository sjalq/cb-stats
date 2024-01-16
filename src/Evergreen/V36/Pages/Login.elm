module Evergreen.V36.Pages.Login exposing (..)

import Evergreen.V36.Api.Data
import Evergreen.V36.Api.User


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
    | GotUser (Evergreen.V36.Api.Data.Data Evergreen.V36.Api.User.User)
