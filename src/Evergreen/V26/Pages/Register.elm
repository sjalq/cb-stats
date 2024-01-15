module Evergreen.V26.Pages.Register exposing (..)

import Evergreen.V26.Api.Data
import Evergreen.V26.Api.User


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
    | GotUser (Evergreen.V26.Api.Data.Data Evergreen.V26.Api.User.User)
