module Evergreen.V38.Gen.Msg exposing (..)

import Evergreen.V38.Pages.Admin
import Evergreen.V38.Pages.Channel.Id_
import Evergreen.V38.Pages.End
import Evergreen.V38.Pages.Example
import Evergreen.V38.Pages.Ga.Email_
import Evergreen.V38.Pages.Home_
import Evergreen.V38.Pages.Log
import Evergreen.V38.Pages.Login
import Evergreen.V38.Pages.Playlist.Id_
import Evergreen.V38.Pages.Register


type Msg
    = Admin Evergreen.V38.Pages.Admin.Msg
    | End Evergreen.V38.Pages.End.Msg
    | Example Evergreen.V38.Pages.Example.Msg
    | Home_ Evergreen.V38.Pages.Home_.Msg
    | Log Evergreen.V38.Pages.Log.Msg
    | Login Evergreen.V38.Pages.Login.Msg
    | Register Evergreen.V38.Pages.Register.Msg
    | Channel__Id_ Evergreen.V38.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V38.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V38.Pages.Playlist.Id_.Msg
