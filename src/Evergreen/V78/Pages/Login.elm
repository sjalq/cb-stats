module Evergreen.V78.Pages.Login exposing (..)

import Evergreen.V78.Api.Data
import Evergreen.V78.Api.User


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
    | GotUser (Evergreen.V78.Api.Data.Data Evergreen.V78.Api.User.User)
