module Evergreen.V19.Pages.Register exposing (..)

import Evergreen.V19.Api.Data
import Evergreen.V19.Api.User


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
    | GotUser (Evergreen.V19.Api.Data.Data Evergreen.V19.Api.User.User)
