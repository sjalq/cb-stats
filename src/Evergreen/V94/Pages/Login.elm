module Evergreen.V94.Pages.Login exposing (..)

import Evergreen.V94.Api.Data
import Evergreen.V94.Api.User


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
    | GotUser (Evergreen.V94.Api.Data.Data Evergreen.V94.Api.User.User)
