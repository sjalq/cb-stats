module Evergreen.V138.Gen.Msg exposing (..)

import Evergreen.V138.Pages.Admin
import Evergreen.V138.Pages.Channel.Id_
import Evergreen.V138.Pages.End
import Evergreen.V138.Pages.Example
import Evergreen.V138.Pages.Ga.Email_
import Evergreen.V138.Pages.Home_
import Evergreen.V138.Pages.Log
import Evergreen.V138.Pages.Login
import Evergreen.V138.Pages.Playlist.Id_
import Evergreen.V138.Pages.Register
import Evergreen.V138.Pages.Video.Id_


type Msg
    = Admin Evergreen.V138.Pages.Admin.Msg
    | End Evergreen.V138.Pages.End.Msg
    | Example Evergreen.V138.Pages.Example.Msg
    | Home_ Evergreen.V138.Pages.Home_.Msg
    | Log Evergreen.V138.Pages.Log.Msg
    | Login Evergreen.V138.Pages.Login.Msg
    | Register Evergreen.V138.Pages.Register.Msg
    | Channel__Id_ Evergreen.V138.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V138.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V138.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V138.Pages.Video.Id_.Msg
