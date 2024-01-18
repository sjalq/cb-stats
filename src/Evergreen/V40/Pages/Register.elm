module Evergreen.V40.Pages.Register exposing (..)

import Evergreen.V40.Api.Data
import Evergreen.V40.Api.User


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
    | GotUser (Evergreen.V40.Api.Data.Data Evergreen.V40.Api.User.User)
