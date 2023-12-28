module Evergreen.V4.Gen.Msg exposing (..)

import Evergreen.V4.Pages.Admin
import Evergreen.V4.Pages.End
import Evergreen.V4.Pages.Example
import Evergreen.V4.Pages.Home_
import Evergreen.V4.Pages.Login
import Evergreen.V4.Pages.Register


type Msg
    = Admin Evergreen.V4.Pages.Admin.Msg
    | End Evergreen.V4.Pages.End.Msg
    | Example Evergreen.V4.Pages.Example.Msg
    | Home_ Evergreen.V4.Pages.Home_.Msg
    | Login Evergreen.V4.Pages.Login.Msg
    | Register Evergreen.V4.Pages.Register.Msg
