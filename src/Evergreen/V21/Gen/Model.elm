module Evergreen.V21.Gen.Model exposing (..)

import Evergreen.V21.Gen.Params.Admin
import Evergreen.V21.Gen.Params.Channel.Id_
import Evergreen.V21.Gen.Params.End
import Evergreen.V21.Gen.Params.Example
import Evergreen.V21.Gen.Params.Ga.Email_
import Evergreen.V21.Gen.Params.Home_
import Evergreen.V21.Gen.Params.Log
import Evergreen.V21.Gen.Params.Login
import Evergreen.V21.Gen.Params.NotFound
import Evergreen.V21.Gen.Params.Playlist.Id_
import Evergreen.V21.Gen.Params.Register
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


type Model
    = Redirecting_
    | Admin Evergreen.V21.Gen.Params.Admin.Params Evergreen.V21.Pages.Admin.Model
    | End Evergreen.V21.Gen.Params.End.Params Evergreen.V21.Pages.End.Model
    | Example Evergreen.V21.Gen.Params.Example.Params Evergreen.V21.Pages.Example.Model
    | Home_ Evergreen.V21.Gen.Params.Home_.Params Evergreen.V21.Pages.Home_.Model
    | Log Evergreen.V21.Gen.Params.Log.Params Evergreen.V21.Pages.Log.Model
    | Login Evergreen.V21.Gen.Params.Login.Params Evergreen.V21.Pages.Login.Model
    | NotFound Evergreen.V21.Gen.Params.NotFound.Params
    | Register Evergreen.V21.Gen.Params.Register.Params Evergreen.V21.Pages.Register.Model
    | Channel__Id_ Evergreen.V21.Gen.Params.Channel.Id_.Params Evergreen.V21.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V21.Gen.Params.Ga.Email_.Params Evergreen.V21.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V21.Gen.Params.Playlist.Id_.Params Evergreen.V21.Pages.Playlist.Id_.Model
