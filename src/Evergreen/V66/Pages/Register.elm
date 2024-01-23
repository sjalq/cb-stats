module Evergreen.V66.Pages.Register exposing (..)

import Evergreen.V66.Api.Data
import Evergreen.V66.Api.User


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
    | GotUser (Evergreen.V66.Api.Data.Data Evergreen.V66.Api.User.User)
