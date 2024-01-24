module Evergreen.V78.Gen.Msg exposing (..)

import Evergreen.V78.Pages.Admin
import Evergreen.V78.Pages.Channel.Id_
import Evergreen.V78.Pages.End
import Evergreen.V78.Pages.Example
import Evergreen.V78.Pages.Ga.Email_
import Evergreen.V78.Pages.Home_
import Evergreen.V78.Pages.Log
import Evergreen.V78.Pages.Login
import Evergreen.V78.Pages.Playlist.Id_
import Evergreen.V78.Pages.Register
import Evergreen.V78.Pages.Video.Id_


type Msg
    = Admin Evergreen.V78.Pages.Admin.Msg
    | End Evergreen.V78.Pages.End.Msg
    | Example Evergreen.V78.Pages.Example.Msg
    | Home_ Evergreen.V78.Pages.Home_.Msg
    | Log Evergreen.V78.Pages.Log.Msg
    | Login Evergreen.V78.Pages.Login.Msg
    | Register Evergreen.V78.Pages.Register.Msg
    | Channel__Id_ Evergreen.V78.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V78.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V78.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V78.Pages.Video.Id_.Msg
