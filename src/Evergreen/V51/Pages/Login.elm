module Evergreen.V51.Pages.Login exposing (..)

import Evergreen.V51.Api.Data
import Evergreen.V51.Api.User


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
    | GotUser (Evergreen.V51.Api.Data.Data Evergreen.V51.Api.User.User)
