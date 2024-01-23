module Evergreen.V66.Gen.Msg exposing (..)

import Evergreen.V66.Pages.Admin
import Evergreen.V66.Pages.Channel.Id_
import Evergreen.V66.Pages.End
import Evergreen.V66.Pages.Example
import Evergreen.V66.Pages.Ga.Email_
import Evergreen.V66.Pages.Home_
import Evergreen.V66.Pages.Log
import Evergreen.V66.Pages.Login
import Evergreen.V66.Pages.Playlist.Id_
import Evergreen.V66.Pages.Register
import Evergreen.V66.Pages.Video.Id_


type Msg
    = Admin Evergreen.V66.Pages.Admin.Msg
    | End Evergreen.V66.Pages.End.Msg
    | Example Evergreen.V66.Pages.Example.Msg
    | Home_ Evergreen.V66.Pages.Home_.Msg
    | Log Evergreen.V66.Pages.Log.Msg
    | Login Evergreen.V66.Pages.Login.Msg
    | Register Evergreen.V66.Pages.Register.Msg
    | Channel__Id_ Evergreen.V66.Pages.Channel.Id_.Msg
    | Ga__Email_ Evergreen.V66.Pages.Ga.Email_.Msg
    | Playlist__Id_ Evergreen.V66.Pages.Playlist.Id_.Msg
    | Video__Id_ Evergreen.V66.Pages.Video.Id_.Msg
