module Evergreen.V5.Gen.Msg exposing (..)

import Evergreen.V5.Pages.Admin
import Evergreen.V5.Pages.Channel.Id_
import Evergreen.V5.Pages.End
import Evergreen.V5.Pages.Example
import Evergreen.V5.Pages.Ga.Email_
import Evergreen.V5.Pages.Home_
import Evergreen.V5.Pages.Login
import Evergreen.V5.Pages.Register


type Msg
    = Admin Evergreen.V5.Pages.Admin.Msg
    | End Evergreen.V5.Pages.End.Msg
    | Example Evergreen.V5.Pages.Example.Msg
    | Home_ Evergreen.V5.Pages.Home_.Msg
    | Login Evergreen.V5.Pages.Login.Msg
    | Register Evergreen.V5.Pages.Register.Msg
    | Channel__Id_ Evergreen.V5.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V5.Pages.Ga.Email_.Msg
