module Evergreen.V11.Pages.Register exposing (..)

import Evergreen.V11.Api.Data
import Evergreen.V11.Api.User


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
    | GotUser (Evergreen.V11.Api.Data.Data Evergreen.V11.Api.User.User)
