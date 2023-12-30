module Evergreen.V5.Pages.Login exposing (..)

import Evergreen.V5.Api.Data
import Evergreen.V5.Api.User


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
    | GotUser (Evergreen.V5.Api.Data.Data Evergreen.V5.Api.User.User)
