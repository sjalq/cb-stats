module Evergreen.V22.Gen.Msg exposing (..)

import Evergreen.V22.Pages.Admin
import Evergreen.V22.Pages.Channel.Id_
import Evergreen.V22.Pages.End
import Evergreen.V22.Pages.Example
import Evergreen.V22.Pages.Ga.Email_
import Evergreen.V22.Pages.Home_
import Evergreen.V22.Pages.Log
import Evergreen.V22.Pages.Login
import Evergreen.V22.Pages.Playlist.Id_
import Evergreen.V22.Pages.Register


type Msg
    = Admin Evergreen.V22.Pages.Admin.Msg
    | End Evergreen.V22.Pages.End.Msg
    | Example Evergreen.V22.Pages.Example.Msg
    | Home_ Evergreen.V22.Pages.Home_.Msg
    | Log Evergreen.V22.Pages.Log.Msg
    | Login Evergreen.V22.Pages.Login.Msg
    | Register Evergreen.V22.Pages.Register.Msg
    | Channel__Id_ Evergreen.V22.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V22.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V22.Pages.Playlist.Id_.Msg
