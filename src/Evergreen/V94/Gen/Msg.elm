module Evergreen.V94.Gen.Msg exposing (..)

import Evergreen.V94.Pages.Admin
import Evergreen.V94.Pages.Channel.Id_
import Evergreen.V94.Pages.End
import Evergreen.V94.Pages.Example
import Evergreen.V94.Pages.Ga.Email_
import Evergreen.V94.Pages.Home_
import Evergreen.V94.Pages.Log
import Evergreen.V94.Pages.Login
import Evergreen.V94.Pages.Playlist.Id_
import Evergreen.V94.Pages.Register
import Evergreen.V94.Pages.Video.Id_


type Msg
    = Admin Evergreen.V94.Pages.Admin.Msg
    | End Evergreen.V94.Pages.End.Msg
    | Example Evergreen.V94.Pages.Example.Msg
    | Home_ Evergreen.V94.Pages.Home_.Msg
    | Log Evergreen.V94.Pages.Log.Msg
    | Login Evergreen.V94.Pages.Login.Msg
    | Register Evergreen.V94.Pages.Register.Msg
    | Channel__Id_ Evergreen.V94.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V94.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V94.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V94.Pages.Video.Id_.Msg
