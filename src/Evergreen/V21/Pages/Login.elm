module Evergreen.V21.Pages.Login exposing (..)

import Evergreen.V21.Api.Data
import Evergreen.V21.Api.User


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
    | GotUser (Evergreen.V21.Api.Data.Data Evergreen.V21.Api.User.User)
