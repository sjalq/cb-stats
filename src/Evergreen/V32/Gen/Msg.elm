module Evergreen.V32.Gen.Msg exposing (..)

import Evergreen.V32.Pages.Admin
import Evergreen.V32.Pages.Channel.Id_
import Evergreen.V32.Pages.End
import Evergreen.V32.Pages.Example
import Evergreen.V32.Pages.Ga.Email_
import Evergreen.V32.Pages.Home_
import Evergreen.V32.Pages.Log
import Evergreen.V32.Pages.Login
import Evergreen.V32.Pages.Playlist.Id_
import Evergreen.V32.Pages.Register


type Msg
    = Admin Evergreen.V32.Pages.Admin.Msg
    | End Evergreen.V32.Pages.End.Msg
    | Example Evergreen.V32.Pages.Example.Msg
    | Home_ Evergreen.V32.Pages.Home_.Msg
    | Log Evergreen.V32.Pages.Log.Msg
    | Login Evergreen.V32.Pages.Login.Msg
    | Register Evergreen.V32.Pages.Register.Msg
    | Channel__Id_ Evergreen.V32.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V32.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V32.Pages.Playlist.Id_.Msg
