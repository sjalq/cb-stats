module Evergreen.V28.Pages.Login exposing (..)

import Evergreen.V28.Api.Data
import Evergreen.V28.Api.User


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
    | GotUser (Evergreen.V28.Api.Data.Data Evergreen.V28.Api.User.User)
