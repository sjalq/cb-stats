module Evergreen.V50.Pages.Register exposing (..)

import Evergreen.V50.Api.Data
import Evergreen.V50.Api.User


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
    | GotUser (Evergreen.V50.Api.Data.Data Evergreen.V50.Api.User.User)
