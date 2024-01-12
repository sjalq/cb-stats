module Evergreen.V19.Gen.Msg exposing (..)

import Evergreen.V19.Pages.Admin
import Evergreen.V19.Pages.Channel.Id_
import Evergreen.V19.Pages.End
import Evergreen.V19.Pages.Example
import Evergreen.V19.Pages.Ga.Email_
import Evergreen.V19.Pages.Home_
import Evergreen.V19.Pages.Log
import Evergreen.V19.Pages.Login
import Evergreen.V19.Pages.Playlist.Id_
import Evergreen.V19.Pages.Register


type Msg
    = Admin Evergreen.V19.Pages.Admin.Msg
    | End Evergreen.V19.Pages.End.Msg
    | Example Evergreen.V19.Pages.Example.Msg
    | Home_ Evergreen.V19.Pages.Home_.Msg
    | Log Evergreen.V19.Pages.Log.Msg
    | Login Evergreen.V19.Pages.Login.Msg
    | Register Evergreen.V19.Pages.Register.Msg
    | Channel__Id_ Evergreen.V19.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V19.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V19.Pages.Playlist.Id_.Msg
