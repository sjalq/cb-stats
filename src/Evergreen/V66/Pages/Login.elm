module Evergreen.V66.Pages.Login exposing (..)

import Evergreen.V66.Api.Data
import Evergreen.V66.Api.User


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
    | GotUser (Evergreen.V66.Api.Data.Data Evergreen.V66.Api.User.User)
