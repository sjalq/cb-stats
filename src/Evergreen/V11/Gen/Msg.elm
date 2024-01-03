module Evergreen.V11.Gen.Msg exposing (..)

import Evergreen.V11.Pages.Admin
import Evergreen.V11.Pages.Channel.Id_
import Evergreen.V11.Pages.End
import Evergreen.V11.Pages.Example
import Evergreen.V11.Pages.Ga.Email_
import Evergreen.V11.Pages.Home_
import Evergreen.V11.Pages.Log
import Evergreen.V11.Pages.Login
import Evergreen.V11.Pages.Playlist.Id_
import Evergreen.V11.Pages.Register


type Msg
    = Admin Evergreen.V11.Pages.Admin.Msg
    | End Evergreen.V11.Pages.End.Msg
    | Example Evergreen.V11.Pages.Example.Msg
    | Home_ Evergreen.V11.Pages.Home_.Msg
    | Log Evergreen.V11.Pages.Log.Msg
    | Login Evergreen.V11.Pages.Login.Msg
    | Register Evergreen.V11.Pages.Register.Msg
    | Channel__Id_ Evergreen.V11.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V11.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V11.Pages.Playlist.Id_.Msg
