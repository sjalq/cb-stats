module Evergreen.V51.Gen.Msg exposing (..)

import Evergreen.V51.Pages.Admin
import Evergreen.V51.Pages.Channel.Id_
import Evergreen.V51.Pages.End
import Evergreen.V51.Pages.Example
import Evergreen.V51.Pages.Ga.Email_
import Evergreen.V51.Pages.Home_
import Evergreen.V51.Pages.Log
import Evergreen.V51.Pages.Login
import Evergreen.V51.Pages.Playlist.Id_
import Evergreen.V51.Pages.Register
import Evergreen.V51.Pages.Video.Id_


type Msg
    = Admin Evergreen.V51.Pages.Admin.Msg
    | End Evergreen.V51.Pages.End.Msg
    | Example Evergreen.V51.Pages.Example.Msg
    | Home_ Evergreen.V51.Pages.Home_.Msg
    | Log Evergreen.V51.Pages.Log.Msg
    | Login Evergreen.V51.Pages.Login.Msg
    | Register Evergreen.V51.Pages.Register.Msg
    | Channel__Id_ Evergreen.V51.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V51.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V51.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V51.Pages.Video.Id_.Msg
