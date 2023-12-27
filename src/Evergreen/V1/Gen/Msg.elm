module Evergreen.V1.Gen.Msg exposing (..)

import Evergreen.V1.Pages.Admin
import Evergreen.V1.Pages.End
import Evergreen.V1.Pages.Example
import Evergreen.V1.Pages.Home_
import Evergreen.V1.Pages.Login
import Evergreen.V1.Pages.Register


type Msg
    = Admin Evergreen.V1.Pages.Admin.Msg
    | End Evergreen.V1.Pages.End.Msg
    | Example Evergreen.V1.Pages.Example.Msg
    | Home_ Evergreen.V1.Pages.Home_.Msg
    | Login Evergreen.V1.Pages.Login.Msg
    | Register Evergreen.V1.Pages.Register.Msg
