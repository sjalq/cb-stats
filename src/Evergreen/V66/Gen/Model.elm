module Evergreen.V66.Gen.Model exposing (..)

import Evergreen.V66.Gen.Params.Admin
import Evergreen.V66.Gen.Params.Channel.Id_
import Evergreen.V66.Gen.Params.End
import Evergreen.V66.Gen.Params.Example
import Evergreen.V66.Gen.Params.Ga.Email_
import Evergreen.V66.Gen.Params.Home_
import Evergreen.V66.Gen.Params.Log
import Evergreen.V66.Gen.Params.Login
import Evergreen.V66.Gen.Params.NotFound
import Evergreen.V66.Gen.Params.Playlist.Id_
import Evergreen.V66.Gen.Params.Register
import Evergreen.V66.Gen.Params.Video.Id_
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


type Model
    = Redirecting_
    | Admin Evergreen.V66.Gen.Params.Admin.Params Evergreen.V66.Pages.Admin.Model
    | End Evergreen.V66.Gen.Params.End.Params Evergreen.V66.Pages.End.Model
    | Example Evergreen.V66.Gen.Params.Example.Params Evergreen.V66.Pages.Example.Model
    | Home_ Evergreen.V66.Gen.Params.Home_.Params Evergreen.V66.Pages.Home_.Model
    | Log Evergreen.V66.Gen.Params.Log.Params Evergreen.V66.Pages.Log.Model
    | Login Evergreen.V66.Gen.Params.Login.Params Evergreen.V66.Pages.Login.Model
    | NotFound Evergreen.V66.Gen.Params.NotFound.Params
    | Register Evergreen.V66.Gen.Params.Register.Params Evergreen.V66.Pages.Register.Model
    | Channel__Id_ Evergreen.V66.Gen.Params.Channel.Id_.Params Evergreen.V66.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V66.Gen.Params.Ga.Email_.Params Evergreen.V66.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V66.Gen.Params.Playlist.Id_.Params Evergreen.V66.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V66.Gen.Params.Video.Id_.Params Evergreen.V66.Pages.Video.Id_.Model
