module Evergreen.V20.Pages.Register exposing (..)

import Evergreen.V20.Api.Data
import Evergreen.V20.Api.User


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
    | GotUser (Evergreen.V20.Api.Data.Data Evergreen.V20.Api.User.User)
