module Evergreen.V16.Pages.Register exposing (..)

import Evergreen.V16.Api.Data
import Evergreen.V16.Api.User


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
    | GotUser (Evergreen.V16.Api.Data.Data Evergreen.V16.Api.User.User)
