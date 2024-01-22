module Evergreen.V54.Pages.Register exposing (..)

import Evergreen.V54.Api.Data
import Evergreen.V54.Api.User


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
    | GotUser (Evergreen.V54.Api.Data.Data Evergreen.V54.Api.User.User)
