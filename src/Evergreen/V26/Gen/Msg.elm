module Evergreen.V26.Gen.Msg exposing (..)

import Evergreen.V26.Pages.Admin
import Evergreen.V26.Pages.Channel.Id_
import Evergreen.V26.Pages.End
import Evergreen.V26.Pages.Example
import Evergreen.V26.Pages.Ga.Email_
import Evergreen.V26.Pages.Home_
import Evergreen.V26.Pages.Log
import Evergreen.V26.Pages.Login
import Evergreen.V26.Pages.Playlist.Id_
import Evergreen.V26.Pages.Register


type Msg
    = Admin Evergreen.V26.Pages.Admin.Msg
    | End Evergreen.V26.Pages.End.Msg
    | Example Evergreen.V26.Pages.Example.Msg
    | Home_ Evergreen.V26.Pages.Home_.Msg
    | Log Evergreen.V26.Pages.Log.Msg
    | Login Evergreen.V26.Pages.Login.Msg
    | Register Evergreen.V26.Pages.Register.Msg
    | Channel__Id_ Evergreen.V26.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V26.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V26.Pages.Playlist.Id_.Msg
