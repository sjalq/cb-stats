module Evergreen.V138.Pages.Register exposing (..)

import Evergreen.V138.Api.Data
import Evergreen.V138.Api.User


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
    | GotUser (Evergreen.V138.Api.Data.Data Evergreen.V138.Api.User.User)
