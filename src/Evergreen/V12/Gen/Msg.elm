module Evergreen.V12.Gen.Msg exposing (..)

import Evergreen.V12.Pages.Admin
import Evergreen.V12.Pages.Channel.Id_
import Evergreen.V12.Pages.End
import Evergreen.V12.Pages.Example
import Evergreen.V12.Pages.Ga.Email_
import Evergreen.V12.Pages.Home_
import Evergreen.V12.Pages.Log
import Evergreen.V12.Pages.Login
import Evergreen.V12.Pages.Playlist.Id_
import Evergreen.V12.Pages.Register


type Msg
    = Admin Evergreen.V12.Pages.Admin.Msg
    | End Evergreen.V12.Pages.End.Msg
    | Example Evergreen.V12.Pages.Example.Msg
    | Home_ Evergreen.V12.Pages.Home_.Msg
    | Log Evergreen.V12.Pages.Log.Msg
    | Login Evergreen.V12.Pages.Login.Msg
    | Register Evergreen.V12.Pages.Register.Msg
    | Channel__Id_ Evergreen.V12.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V12.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V12.Pages.Playlist.Id_.Msg
