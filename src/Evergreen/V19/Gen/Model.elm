module Evergreen.V19.Gen.Model exposing (..)

import Evergreen.V19.Gen.Params.Admin
import Evergreen.V19.Gen.Params.Channel.Id_
import Evergreen.V19.Gen.Params.End
import Evergreen.V19.Gen.Params.Example
import Evergreen.V19.Gen.Params.Ga.Email_
import Evergreen.V19.Gen.Params.Home_
import Evergreen.V19.Gen.Params.Log
import Evergreen.V19.Gen.Params.Login
import Evergreen.V19.Gen.Params.NotFound
import Evergreen.V19.Gen.Params.Playlist.Id_
import Evergreen.V19.Gen.Params.Register
import Evergreen.V19.Pages.Admin
import Evergreen.V19.Pages.Channel.Id_
import Evergreen.V19.Pages.End
import Evergreen.V19.Pages.Example
import Evergreen.V19.Pages.Ga.Email_
import Evergreen.V19.Pages.Home_
import Evergreen.V19.Pages.Log
import Evergreen.V19.Pages.Login
import Evergreen.V19.Pages.Playlist.Id_
import Evergreen.V19.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V19.Gen.Params.Admin.Params Evergreen.V19.Pages.Admin.Model
    | End Evergreen.V19.Gen.Params.End.Params Evergreen.V19.Pages.End.Model
    | Example Evergreen.V19.Gen.Params.Example.Params Evergreen.V19.Pages.Example.Model
    | Home_ Evergreen.V19.Gen.Params.Home_.Params Evergreen.V19.Pages.Home_.Model
    | Log Evergreen.V19.Gen.Params.Log.Params Evergreen.V19.Pages.Log.Model
    | Login Evergreen.V19.Gen.Params.Login.Params Evergreen.V19.Pages.Login.Model
    | NotFound Evergreen.V19.Gen.Params.NotFound.Params
    | Register Evergreen.V19.Gen.Params.Register.Params Evergreen.V19.Pages.Register.Model
    | Channel__Id_ Evergreen.V19.Gen.Params.Channel.Id_.Params Evergreen.V19.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V19.Gen.Params.Ga.Email_.Params Evergreen.V19.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V19.Gen.Params.Playlist.Id_.Params Evergreen.V19.Pages.Playlist.Id_.Model
