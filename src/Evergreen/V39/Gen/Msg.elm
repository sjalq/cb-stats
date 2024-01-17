module Evergreen.V39.Gen.Msg exposing (..)

import Evergreen.V39.Pages.Admin
import Evergreen.V39.Pages.Channel.Id_
import Evergreen.V39.Pages.End
import Evergreen.V39.Pages.Example
import Evergreen.V39.Pages.Ga.Email_
import Evergreen.V39.Pages.Home_
import Evergreen.V39.Pages.Log
import Evergreen.V39.Pages.Login
import Evergreen.V39.Pages.Playlist.Id_
import Evergreen.V39.Pages.Register


type Msg
    = Admin Evergreen.V39.Pages.Admin.Msg
    | End Evergreen.V39.Pages.End.Msg
    | Example Evergreen.V39.Pages.Example.Msg
    | Home_ Evergreen.V39.Pages.Home_.Msg
    | Log Evergreen.V39.Pages.Log.Msg
    | Login Evergreen.V39.Pages.Login.Msg
    | Register Evergreen.V39.Pages.Register.Msg
    | Channel__Id_ Evergreen.V39.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V39.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V39.Pages.Playlist.Id_.Msg
