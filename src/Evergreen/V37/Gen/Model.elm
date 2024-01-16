module Evergreen.V37.Gen.Model exposing (..)

import Evergreen.V37.Gen.Params.Admin
import Evergreen.V37.Gen.Params.Channel.Id_
import Evergreen.V37.Gen.Params.End
import Evergreen.V37.Gen.Params.Example
import Evergreen.V37.Gen.Params.Ga.Email_
import Evergreen.V37.Gen.Params.Home_
import Evergreen.V37.Gen.Params.Log
import Evergreen.V37.Gen.Params.Login
import Evergreen.V37.Gen.Params.NotFound
import Evergreen.V37.Gen.Params.Playlist.Id_
import Evergreen.V37.Gen.Params.Register
import Evergreen.V37.Pages.Admin
import Evergreen.V37.Pages.Channel.Id_
import Evergreen.V37.Pages.End
import Evergreen.V37.Pages.Example
import Evergreen.V37.Pages.Ga.Email_
import Evergreen.V37.Pages.Home_
import Evergreen.V37.Pages.Log
import Evergreen.V37.Pages.Login
import Evergreen.V37.Pages.Playlist.Id_
import Evergreen.V37.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V37.Gen.Params.Admin.Params Evergreen.V37.Pages.Admin.Model
    | End Evergreen.V37.Gen.Params.End.Params Evergreen.V37.Pages.End.Model
    | Example Evergreen.V37.Gen.Params.Example.Params Evergreen.V37.Pages.Example.Model
    | Home_ Evergreen.V37.Gen.Params.Home_.Params Evergreen.V37.Pages.Home_.Model
    | Log Evergreen.V37.Gen.Params.Log.Params Evergreen.V37.Pages.Log.Model
    | Login Evergreen.V37.Gen.Params.Login.Params Evergreen.V37.Pages.Login.Model
    | NotFound Evergreen.V37.Gen.Params.NotFound.Params
    | Register Evergreen.V37.Gen.Params.Register.Params Evergreen.V37.Pages.Register.Model
    | Channel__Id_ Evergreen.V37.Gen.Params.Channel.Id_.Params Evergreen.V37.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V37.Gen.Params.Ga.Email_.Params Evergreen.V37.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V37.Gen.Params.Playlist.Id_.Params Evergreen.V37.Pages.Playlist.Id_.Model
