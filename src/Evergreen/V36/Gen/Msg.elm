module Evergreen.V36.Gen.Msg exposing (..)

import Evergreen.V36.Pages.Admin
import Evergreen.V36.Pages.Channel.Id_
import Evergreen.V36.Pages.End
import Evergreen.V36.Pages.Example
import Evergreen.V36.Pages.Ga.Email_
import Evergreen.V36.Pages.Home_
import Evergreen.V36.Pages.Log
import Evergreen.V36.Pages.Login
import Evergreen.V36.Pages.Playlist.Id_
import Evergreen.V36.Pages.Register


type Msg
    = Admin Evergreen.V36.Pages.Admin.Msg
    | End Evergreen.V36.Pages.End.Msg
    | Example Evergreen.V36.Pages.Example.Msg
    | Home_ Evergreen.V36.Pages.Home_.Msg
    | Log Evergreen.V36.Pages.Log.Msg
    | Login Evergreen.V36.Pages.Login.Msg
    | Register Evergreen.V36.Pages.Register.Msg
    | Channel__Id_ Evergreen.V36.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V36.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V36.Pages.Playlist.Id_.Msg
