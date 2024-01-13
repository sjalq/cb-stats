module Evergreen.V20.Pages.Login exposing (..)

import Evergreen.V20.Api.Data
import Evergreen.V20.Api.User


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
    | GotUser (Evergreen.V20.Api.Data.Data Evergreen.V20.Api.User.User)
