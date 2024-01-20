module Evergreen.V48.Gen.Msg exposing (..)

import Evergreen.V48.Pages.Admin
import Evergreen.V48.Pages.Channel.Id_
import Evergreen.V48.Pages.End
import Evergreen.V48.Pages.Example
import Evergreen.V48.Pages.Ga.Email_
import Evergreen.V48.Pages.Home_
import Evergreen.V48.Pages.Log
import Evergreen.V48.Pages.Login
import Evergreen.V48.Pages.Playlist.Id_
import Evergreen.V48.Pages.Register
import Evergreen.V48.Pages.Video.Id_


type Msg
    = Admin Evergreen.V48.Pages.Admin.Msg
    | End Evergreen.V48.Pages.End.Msg
    | Example Evergreen.V48.Pages.Example.Msg
    | Home_ Evergreen.V48.Pages.Home_.Msg
    | Log Evergreen.V48.Pages.Log.Msg
    | Login Evergreen.V48.Pages.Login.Msg
    | Register Evergreen.V48.Pages.Register.Msg
    | Channel__Id_ Evergreen.V48.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V48.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V48.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V48.Pages.Video.Id_.Msg
