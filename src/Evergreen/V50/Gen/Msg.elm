module Evergreen.V50.Gen.Msg exposing (..)

import Evergreen.V50.Pages.Admin
import Evergreen.V50.Pages.Channel.Id_
import Evergreen.V50.Pages.End
import Evergreen.V50.Pages.Example
import Evergreen.V50.Pages.Ga.Email_
import Evergreen.V50.Pages.Home_
import Evergreen.V50.Pages.Log
import Evergreen.V50.Pages.Login
import Evergreen.V50.Pages.Playlist.Id_
import Evergreen.V50.Pages.Register
import Evergreen.V50.Pages.Video.Id_


type Msg
    = Admin Evergreen.V50.Pages.Admin.Msg
    | End Evergreen.V50.Pages.End.Msg
    | Example Evergreen.V50.Pages.Example.Msg
    | Home_ Evergreen.V50.Pages.Home_.Msg
    | Log Evergreen.V50.Pages.Log.Msg
    | Login Evergreen.V50.Pages.Login.Msg
    | Register Evergreen.V50.Pages.Register.Msg
    | Channel__Id_ Evergreen.V50.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V50.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V50.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V50.Pages.Video.Id_.Msg
