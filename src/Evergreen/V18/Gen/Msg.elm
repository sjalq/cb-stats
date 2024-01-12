module Evergreen.V18.Gen.Msg exposing (..)

import Evergreen.V18.Pages.Admin
import Evergreen.V18.Pages.Channel.Id_
import Evergreen.V18.Pages.End
import Evergreen.V18.Pages.Example
import Evergreen.V18.Pages.Ga.Email_
import Evergreen.V18.Pages.Home_
import Evergreen.V18.Pages.Log
import Evergreen.V18.Pages.Login
import Evergreen.V18.Pages.Playlist.Id_
import Evergreen.V18.Pages.Register


type Msg
    = Admin Evergreen.V18.Pages.Admin.Msg
    | End Evergreen.V18.Pages.End.Msg
    | Example Evergreen.V18.Pages.Example.Msg
    | Home_ Evergreen.V18.Pages.Home_.Msg
    | Log Evergreen.V18.Pages.Log.Msg
    | Login Evergreen.V18.Pages.Login.Msg
    | Register Evergreen.V18.Pages.Register.Msg
    | Channel__Id_ Evergreen.V18.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V18.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V18.Pages.Playlist.Id_.Msg
