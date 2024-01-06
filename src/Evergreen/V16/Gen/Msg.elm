module Evergreen.V16.Gen.Msg exposing (..)

import Evergreen.V16.Pages.Admin
import Evergreen.V16.Pages.Channel.Id_
import Evergreen.V16.Pages.End
import Evergreen.V16.Pages.Example
import Evergreen.V16.Pages.Ga.Email_
import Evergreen.V16.Pages.Home_
import Evergreen.V16.Pages.Log
import Evergreen.V16.Pages.Login
import Evergreen.V16.Pages.Playlist.Id_
import Evergreen.V16.Pages.Register


type Msg
    = Admin Evergreen.V16.Pages.Admin.Msg
    | End Evergreen.V16.Pages.End.Msg
    | Example Evergreen.V16.Pages.Example.Msg
    | Home_ Evergreen.V16.Pages.Home_.Msg
    | Log Evergreen.V16.Pages.Log.Msg
    | Login Evergreen.V16.Pages.Login.Msg
    | Register Evergreen.V16.Pages.Register.Msg
    | Channel__Id_ Evergreen.V16.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V16.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V16.Pages.Playlist.Id_.Msg
