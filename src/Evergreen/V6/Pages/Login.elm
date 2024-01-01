module Evergreen.V6.Pages.Login exposing (..)

import Evergreen.V6.Api.Data
import Evergreen.V6.Api.User


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
    | GotUser (Evergreen.V6.Api.Data.Data Evergreen.V6.Api.User.User)
