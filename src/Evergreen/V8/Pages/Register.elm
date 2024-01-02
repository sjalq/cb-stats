module Evergreen.V8.Pages.Register exposing (..)

import Evergreen.V8.Api.Data
import Evergreen.V8.Api.User


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
    | GotUser (Evergreen.V8.Api.Data.Data Evergreen.V8.Api.User.User)
