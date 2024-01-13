module Evergreen.V20.Gen.Msg exposing (..)

import Evergreen.V20.Pages.Admin
import Evergreen.V20.Pages.Channel.Id_
import Evergreen.V20.Pages.End
import Evergreen.V20.Pages.Example
import Evergreen.V20.Pages.Ga.Email_
import Evergreen.V20.Pages.Home_
import Evergreen.V20.Pages.Log
import Evergreen.V20.Pages.Login
import Evergreen.V20.Pages.Playlist.Id_
import Evergreen.V20.Pages.Register


type Msg
    = Admin Evergreen.V20.Pages.Admin.Msg
    | End Evergreen.V20.Pages.End.Msg
    | Example Evergreen.V20.Pages.Example.Msg
    | Home_ Evergreen.V20.Pages.Home_.Msg
    | Log Evergreen.V20.Pages.Log.Msg
    | Login Evergreen.V20.Pages.Login.Msg
    | Register Evergreen.V20.Pages.Register.Msg
    | Channel__Id_ Evergreen.V20.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V20.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V20.Pages.Playlist.Id_.Msg
