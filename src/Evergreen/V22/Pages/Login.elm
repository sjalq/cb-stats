module Evergreen.V22.Pages.Login exposing (..)

import Evergreen.V22.Api.Data
import Evergreen.V22.Api.User


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
    | GotUser (Evergreen.V22.Api.Data.Data Evergreen.V22.Api.User.User)
