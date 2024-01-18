module Evergreen.V40.Gen.Msg exposing (..)

import Evergreen.V40.Pages.Admin
import Evergreen.V40.Pages.Channel.Id_
import Evergreen.V40.Pages.End
import Evergreen.V40.Pages.Example
import Evergreen.V40.Pages.Ga.Email_
import Evergreen.V40.Pages.Home_
import Evergreen.V40.Pages.Log
import Evergreen.V40.Pages.Login
import Evergreen.V40.Pages.Playlist.Id_
import Evergreen.V40.Pages.Register
import Evergreen.V40.Pages.Video.Id_


type Msg
    = Admin Evergreen.V40.Pages.Admin.Msg
    | End Evergreen.V40.Pages.End.Msg
    | Example Evergreen.V40.Pages.Example.Msg
    | Home_ Evergreen.V40.Pages.Home_.Msg
    | Log Evergreen.V40.Pages.Log.Msg
    | Login Evergreen.V40.Pages.Login.Msg
    | Register Evergreen.V40.Pages.Register.Msg
    | Channel__Id_ Evergreen.V40.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V40.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V40.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V40.Pages.Video.Id_.Msg
