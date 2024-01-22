module Evergreen.V54.Gen.Msg exposing (..)

import Evergreen.V54.Pages.Admin
import Evergreen.V54.Pages.Channel.Id_
import Evergreen.V54.Pages.End
import Evergreen.V54.Pages.Example
import Evergreen.V54.Pages.Ga.Email_
import Evergreen.V54.Pages.Home_
import Evergreen.V54.Pages.Log
import Evergreen.V54.Pages.Login
import Evergreen.V54.Pages.Playlist.Id_
import Evergreen.V54.Pages.Register
import Evergreen.V54.Pages.Video.Id_


type Msg
    = Admin Evergreen.V54.Pages.Admin.Msg
    | End Evergreen.V54.Pages.End.Msg
    | Example Evergreen.V54.Pages.Example.Msg
    | Home_ Evergreen.V54.Pages.Home_.Msg
    | Log Evergreen.V54.Pages.Log.Msg
    | Login Evergreen.V54.Pages.Login.Msg
    | Register Evergreen.V54.Pages.Register.Msg
    | Channel__Id_ Evergreen.V54.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V54.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V54.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V54.Pages.Video.Id_.Msg
