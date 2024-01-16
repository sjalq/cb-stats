module Evergreen.V35.Pages.Login exposing (..)

import Evergreen.V35.Api.Data
import Evergreen.V35.Api.User


type alias Model =
    { email : String
    , password : String
    , showPassword : Bool
    , errorMessage : Maybe String
    }


type Field
    = Email
    | Password


type Msg
    = Updated Field String
    | ToggledShowPassword
    | ClickedSubmit
    | GotUser (Evergreen.V35.Api.Data.Data Evergreen.V35.Api.User.User)
