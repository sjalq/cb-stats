module Evergreen.V28.Gen.Msg exposing (..)

import Evergreen.V28.Pages.Admin
import Evergreen.V28.Pages.Channel.Id_
import Evergreen.V28.Pages.End
import Evergreen.V28.Pages.Example
import Evergreen.V28.Pages.Ga.Email_
import Evergreen.V28.Pages.Home_
import Evergreen.V28.Pages.Log
import Evergreen.V28.Pages.Login
import Evergreen.V28.Pages.Playlist.Id_
import Evergreen.V28.Pages.Register


type Msg
    = Admin Evergreen.V28.Pages.Admin.Msg
    | End Evergreen.V28.Pages.End.Msg
    | Example Evergreen.V28.Pages.Example.Msg
    | Home_ Evergreen.V28.Pages.Home_.Msg
    | Log Evergreen.V28.Pages.Log.Msg
    | Login Evergreen.V28.Pages.Login.Msg
    | Register Evergreen.V28.Pages.Register.Msg
    | Channel__Id_ Evergreen.V28.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V28.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V28.Pages.Playlist.Id_.Msg
