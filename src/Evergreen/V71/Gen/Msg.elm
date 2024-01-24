module Evergreen.V71.Gen.Msg exposing (..)

import Evergreen.V71.Pages.Admin
import Evergreen.V71.Pages.Channel.Id_
import Evergreen.V71.Pages.End
import Evergreen.V71.Pages.Example
import Evergreen.V71.Pages.Ga.Email_
import Evergreen.V71.Pages.Home_
import Evergreen.V71.Pages.Log
import Evergreen.V71.Pages.Login
import Evergreen.V71.Pages.Playlist.Id_
import Evergreen.V71.Pages.Register
import Evergreen.V71.Pages.Video.Id_


type Msg
    = Admin Evergreen.V71.Pages.Admin.Msg
    | End Evergreen.V71.Pages.End.Msg
    | Example Evergreen.V71.Pages.Example.Msg
    | Home_ Evergreen.V71.Pages.Home_.Msg
    | Log Evergreen.V71.Pages.Log.Msg
    | Login Evergreen.V71.Pages.Login.Msg
    | Register Evergreen.V71.Pages.Register.Msg
    | Channel__Id_ Evergreen.V71.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V71.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V71.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V71.Pages.Video.Id_.Msg
