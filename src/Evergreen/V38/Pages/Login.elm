module Evergreen.V38.Pages.Login exposing (..)

import Evergreen.V38.Api.Data
import Evergreen.V38.Api.User


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
    | GotUser (Evergreen.V38.Api.Data.Data Evergreen.V38.Api.User.User)
