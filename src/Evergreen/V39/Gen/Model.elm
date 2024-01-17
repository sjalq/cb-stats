module Evergreen.V39.Gen.Model exposing (..)

import Evergreen.V39.Gen.Params.Admin
import Evergreen.V39.Gen.Params.Channel.Id_
import Evergreen.V39.Gen.Params.End
import Evergreen.V39.Gen.Params.Example
import Evergreen.V39.Gen.Params.Ga.Email_
import Evergreen.V39.Gen.Params.Home_
import Evergreen.V39.Gen.Params.Log
import Evergreen.V39.Gen.Params.Login
import Evergreen.V39.Gen.Params.NotFound
import Evergreen.V39.Gen.Params.Playlist.Id_
import Evergreen.V39.Gen.Params.Register
import Evergreen.V39.Pages.Admin
import Evergreen.V39.Pages.Channel.Id_
import Evergreen.V39.Pages.End
import Evergreen.V39.Pages.Example
import Evergreen.V39.Pages.Ga.Email_
import Evergreen.V39.Pages.Home_
import Evergreen.V39.Pages.Log
import Evergreen.V39.Pages.Login
import Evergreen.V39.Pages.Playlist.Id_
import Evergreen.V39.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V39.Gen.Params.Admin.Params Evergreen.V39.Pages.Admin.Model
    | End Evergreen.V39.Gen.Params.End.Params Evergreen.V39.Pages.End.Model
    | Example Evergreen.V39.Gen.Params.Example.Params Evergreen.V39.Pages.Example.Model
    | Home_ Evergreen.V39.Gen.Params.Home_.Params Evergreen.V39.Pages.Home_.Model
    | Log Evergreen.V39.Gen.Params.Log.Params Evergreen.V39.Pages.Log.Model
    | Login Evergreen.V39.Gen.Params.Login.Params Evergreen.V39.Pages.Login.Model
    | NotFound Evergreen.V39.Gen.Params.NotFound.Params
    | Register Evergreen.V39.Gen.Params.Register.Params Evergreen.V39.Pages.Register.Model
    | Channel__Id_ Evergreen.V39.Gen.Params.Channel.Id_.Params Evergreen.V39.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V39.Gen.Params.Ga.Email_.Params Evergreen.V39.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V39.Gen.Params.Playlist.Id_.Params Evergreen.V39.Pages.Playlist.Id_.Model
