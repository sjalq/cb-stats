module Evergreen.V37.Gen.Msg exposing (..)

import Evergreen.V37.Pages.Admin
import Evergreen.V37.Pages.Channel.Id_
import Evergreen.V37.Pages.End
import Evergreen.V37.Pages.Example
import Evergreen.V37.Pages.Ga.Email_
import Evergreen.V37.Pages.Home_
import Evergreen.V37.Pages.Log
import Evergreen.V37.Pages.Login
import Evergreen.V37.Pages.Playlist.Id_
import Evergreen.V37.Pages.Register


type Msg
    = Admin Evergreen.V37.Pages.Admin.Msg
    | End Evergreen.V37.Pages.End.Msg
    | Example Evergreen.V37.Pages.Example.Msg
    | Home_ Evergreen.V37.Pages.Home_.Msg
    | Log Evergreen.V37.Pages.Log.Msg
    | Login Evergreen.V37.Pages.Login.Msg
    | Register Evergreen.V37.Pages.Register.Msg
    | Channel__Id_ Evergreen.V37.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V37.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V37.Pages.Playlist.Id_.Msg
