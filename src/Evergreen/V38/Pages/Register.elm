module Evergreen.V38.Pages.Register exposing (..)

import Evergreen.V38.Api.Data
import Evergreen.V38.Api.User


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
    | GotUser (Evergreen.V38.Api.Data.Data Evergreen.V38.Api.User.User)
