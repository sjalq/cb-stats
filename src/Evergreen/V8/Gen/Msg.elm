module Evergreen.V8.Gen.Msg exposing (..)

import Evergreen.V8.Pages.Admin
import Evergreen.V8.Pages.Channel.Id_
import Evergreen.V8.Pages.End
import Evergreen.V8.Pages.Example
import Evergreen.V8.Pages.Ga.Email_
import Evergreen.V8.Pages.Home_
import Evergreen.V8.Pages.Log
import Evergreen.V8.Pages.Login
import Evergreen.V8.Pages.Playlist.Id_
import Evergreen.V8.Pages.Register


type Msg
    = Admin Evergreen.V8.Pages.Admin.Msg
    | End Evergreen.V8.Pages.End.Msg
    | Example Evergreen.V8.Pages.Example.Msg
    | Home_ Evergreen.V8.Pages.Home_.Msg
    | Log Evergreen.V8.Pages.Log.Msg
    | Login Evergreen.V8.Pages.Login.Msg
    | Register Evergreen.V8.Pages.Register.Msg
    | Channel__Id_ Evergreen.V8.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V8.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V8.Pages.Playlist.Id_.Msg
