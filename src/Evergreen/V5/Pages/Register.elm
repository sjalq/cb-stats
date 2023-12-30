module Evergreen.V5.Pages.Register exposing (..)

import Evergreen.V5.Api.Data
import Evergreen.V5.Api.User


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
    | GotUser (Evergreen.V5.Api.Data.Data Evergreen.V5.Api.User.User)
