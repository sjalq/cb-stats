module Evergreen.V1.Pages.Register exposing (..)

import Evergreen.V1.Api.Data
import Evergreen.V1.Api.User


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
    | GotUser (Evergreen.V1.Api.Data.Data Evergreen.V1.Api.User.User)
