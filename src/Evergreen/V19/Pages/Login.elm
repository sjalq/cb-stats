module Evergreen.V19.Pages.Login exposing (..)

import Evergreen.V19.Api.Data
import Evergreen.V19.Api.User


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
    | GotUser (Evergreen.V19.Api.Data.Data Evergreen.V19.Api.User.User)
