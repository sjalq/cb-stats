module Evergreen.V6.Gen.Msg exposing (..)

import Evergreen.V6.Pages.Admin
import Evergreen.V6.Pages.Channel.Id_
import Evergreen.V6.Pages.End
import Evergreen.V6.Pages.Example
import Evergreen.V6.Pages.Ga.Email_
import Evergreen.V6.Pages.Home_
import Evergreen.V6.Pages.Log
import Evergreen.V6.Pages.Login
import Evergreen.V6.Pages.Register


type Msg
    = Admin Evergreen.V6.Pages.Admin.Msg
    | End Evergreen.V6.Pages.End.Msg
    | Example Evergreen.V6.Pages.Example.Msg
    | Home_ Evergreen.V6.Pages.Home_.Msg
    | Log Evergreen.V6.Pages.Log.Msg
    | Login Evergreen.V6.Pages.Login.Msg
    | Register Evergreen.V6.Pages.Register.Msg
    | Channel__Id_ Evergreen.V6.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V6.Pages.Ga.Email_.Msg
