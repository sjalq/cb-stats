module Evergreen.V48.Pages.Register exposing (..)

import Evergreen.V48.Api.Data
import Evergreen.V48.Api.User


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
    | GotUser (Evergreen.V48.Api.Data.Data Evergreen.V48.Api.User.User)
