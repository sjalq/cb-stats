module Evergreen.V77.Pages.Login exposing (..)

import Evergreen.V77.Api.Data
import Evergreen.V77.Api.User


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
    | GotUser (Evergreen.V77.Api.Data.Data Evergreen.V77.Api.User.User)
