module Evergreen.V32.Pages.Register exposing (..)

import Evergreen.V32.Api.Data
import Evergreen.V32.Api.User


type alias Model =
    { email : String
    , password : String
    , errorMessage : Maybe String
    , showPassword : Bool
    }


type Field
    = Email
    | Password


type Msg
    = Updated Field String
    | ToggledShowPassword
    | ClickedSubmit
    | GotUser (Evergreen.V32.Api.Data.Data Evergreen.V32.Api.User.User)
