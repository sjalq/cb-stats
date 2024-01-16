module Evergreen.V35.Pages.Register exposing (..)

import Evergreen.V35.Api.Data
import Evergreen.V35.Api.User


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
    | GotUser (Evergreen.V35.Api.Data.Data Evergreen.V35.Api.User.User)
