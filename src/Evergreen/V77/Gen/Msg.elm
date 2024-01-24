module Evergreen.V77.Gen.Msg exposing (..)

import Evergreen.V77.Pages.Admin
import Evergreen.V77.Pages.Channel.Id_
import Evergreen.V77.Pages.End
import Evergreen.V77.Pages.Example
import Evergreen.V77.Pages.Ga.Email_
import Evergreen.V77.Pages.Home_
import Evergreen.V77.Pages.Log
import Evergreen.V77.Pages.Login
import Evergreen.V77.Pages.Playlist.Id_
import Evergreen.V77.Pages.Register
import Evergreen.V77.Pages.Video.Id_


type Msg
    = Admin Evergreen.V77.Pages.Admin.Msg
    | End Evergreen.V77.Pages.End.Msg
    | Example Evergreen.V77.Pages.Example.Msg
    | Home_ Evergreen.V77.Pages.Home_.Msg
    | Log Evergreen.V77.Pages.Log.Msg
    | Login Evergreen.V77.Pages.Login.Msg
    | Register Evergreen.V77.Pages.Register.Msg
    | Channel__Id_ Evergreen.V77.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V77.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V77.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V77.Pages.Video.Id_.Msg
