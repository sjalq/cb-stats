module Evergreen.V12.Gen.Model exposing (..)

import Evergreen.V12.Gen.Params.Admin
import Evergreen.V12.Gen.Params.Channel.Id_
import Evergreen.V12.Gen.Params.End
import Evergreen.V12.Gen.Params.Example
import Evergreen.V12.Gen.Params.Ga.Email_
import Evergreen.V12.Gen.Params.Home_
import Evergreen.V12.Gen.Params.Log
import Evergreen.V12.Gen.Params.Login
import Evergreen.V12.Gen.Params.NotFound
import Evergreen.V12.Gen.Params.Playlist.Id_
import Evergreen.V12.Gen.Params.Register
import Evergreen.V12.Pages.Admin
import Evergreen.V12.Pages.Channel.Id_
import Evergreen.V12.Pages.End
import Evergreen.V12.Pages.Example
import Evergreen.V12.Pages.Ga.Email_
import Evergreen.V12.Pages.Home_
import Evergreen.V12.Pages.Log
import Evergreen.V12.Pages.Login
import Evergreen.V12.Pages.Playlist.Id_
import Evergreen.V12.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V12.Gen.Params.Admin.Params Evergreen.V12.Pages.Admin.Model
    | End Evergreen.V12.Gen.Params.End.Params Evergreen.V12.Pages.End.Model
    | Example Evergreen.V12.Gen.Params.Example.Params Evergreen.V12.Pages.Example.Model
    | Home_ Evergreen.V12.Gen.Params.Home_.Params Evergreen.V12.Pages.Home_.Model
    | Log Evergreen.V12.Gen.Params.Log.Params Evergreen.V12.Pages.Log.Model
    | Login Evergreen.V12.Gen.Params.Login.Params Evergreen.V12.Pages.Login.Model
    | NotFound Evergreen.V12.Gen.Params.NotFound.Params
    | Register Evergreen.V12.Gen.Params.Register.Params Evergreen.V12.Pages.Register.Model
    | Channel__Id_ Evergreen.V12.Gen.Params.Channel.Id_.Params Evergreen.V12.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V12.Gen.Params.Ga.Email_.Params Evergreen.V12.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V12.Gen.Params.Playlist.Id_.Params Evergreen.V12.Pages.Playlist.Id_.Model
