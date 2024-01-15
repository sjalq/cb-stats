module Evergreen.V26.Pages.Login exposing (..)

import Evergreen.V26.Api.Data
import Evergreen.V26.Api.User


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
    | GotUser (Evergreen.V26.Api.Data.Data Evergreen.V26.Api.User.User)
