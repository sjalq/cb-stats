module Evergreen.V39.Pages.Login exposing (..)

import Evergreen.V39.Api.Data
import Evergreen.V39.Api.User


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
    | GotUser (Evergreen.V39.Api.Data.Data Evergreen.V39.Api.User.User)
