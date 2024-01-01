module Evergreen.V6.Pages.Register exposing (..)

import Evergreen.V6.Api.Data
import Evergreen.V6.Api.User


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
    | GotUser (Evergreen.V6.Api.Data.Data Evergreen.V6.Api.User.User)
