module Evergreen.V18.Pages.Login exposing (..)

import Evergreen.V18.Api.Data
import Evergreen.V18.Api.User


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
    | GotUser (Evergreen.V18.Api.Data.Data Evergreen.V18.Api.User.User)
