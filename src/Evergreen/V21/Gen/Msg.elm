module Evergreen.V21.Gen.Msg exposing (..)

import Evergreen.V21.Pages.Admin
import Evergreen.V21.Pages.Channel.Id_
import Evergreen.V21.Pages.End
import Evergreen.V21.Pages.Example
import Evergreen.V21.Pages.Ga.Email_
import Evergreen.V21.Pages.Home_
import Evergreen.V21.Pages.Log
import Evergreen.V21.Pages.Login
import Evergreen.V21.Pages.Playlist.Id_
import Evergreen.V21.Pages.Register


type Msg
    = Admin Evergreen.V21.Pages.Admin.Msg
    | End Evergreen.V21.Pages.End.Msg
    | Example Evergreen.V21.Pages.Example.Msg
    | Home_ Evergreen.V21.Pages.Home_.Msg
    | Log Evergreen.V21.Pages.Log.Msg
    | Login Evergreen.V21.Pages.Login.Msg
    | Register Evergreen.V21.Pages.Register.Msg
    | Channel__Id_ Evergreen.V21.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V21.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V21.Pages.Playlist.Id_.Msg
