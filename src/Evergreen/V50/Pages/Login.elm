module Evergreen.V50.Pages.Login exposing (..)

import Evergreen.V50.Api.Data
import Evergreen.V50.Api.User


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
    | GotUser (Evergreen.V50.Api.Data.Data Evergreen.V50.Api.User.User)
