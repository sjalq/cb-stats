module Evergreen.V35.Gen.Msg exposing (..)

import Evergreen.V35.Pages.Admin
import Evergreen.V35.Pages.Channel.Id_
import Evergreen.V35.Pages.End
import Evergreen.V35.Pages.Example
import Evergreen.V35.Pages.Ga.Email_
import Evergreen.V35.Pages.Home_
import Evergreen.V35.Pages.Log
import Evergreen.V35.Pages.Login
import Evergreen.V35.Pages.Playlist.Id_
import Evergreen.V35.Pages.Register


type Msg
    = Admin Evergreen.V35.Pages.Admin.Msg
    | End Evergreen.V35.Pages.End.Msg
    | Example Evergreen.V35.Pages.Example.Msg
    | Home_ Evergreen.V35.Pages.Home_.Msg
    | Log Evergreen.V35.Pages.Log.Msg
    | Login Evergreen.V35.Pages.Login.Msg
    | Register Evergreen.V35.Pages.Register.Msg
    | Channel__Id_ Evergreen.V35.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V35.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V35.Pages.Playlist.Id_.Msg
