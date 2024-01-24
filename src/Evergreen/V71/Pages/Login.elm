module Evergreen.V71.Pages.Login exposing (..)

import Evergreen.V71.Api.Data
import Evergreen.V71.Api.User


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
    | GotUser (Evergreen.V71.Api.Data.Data Evergreen.V71.Api.User.User)
