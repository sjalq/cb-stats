module Evergreen.V32.Gen.Model exposing (..)

import Evergreen.V32.Gen.Params.Admin
import Evergreen.V32.Gen.Params.Channel.Id_
import Evergreen.V32.Gen.Params.End
import Evergreen.V32.Gen.Params.Example
import Evergreen.V32.Gen.Params.Ga.Email_
import Evergreen.V32.Gen.Params.Home_
import Evergreen.V32.Gen.Params.Log
import Evergreen.V32.Gen.Params.Login
import Evergreen.V32.Gen.Params.NotFound
import Evergreen.V32.Gen.Params.Playlist.Id_
import Evergreen.V32.Gen.Params.Register
import Evergreen.V32.Pages.Admin
import Evergreen.V32.Pages.Channel.Id_
import Evergreen.V32.Pages.End
import Evergreen.V32.Pages.Example
import Evergreen.V32.Pages.Ga.Email_
import Evergreen.V32.Pages.Home_
import Evergreen.V32.Pages.Log
import Evergreen.V32.Pages.Login
import Evergreen.V32.Pages.Playlist.Id_
import Evergreen.V32.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V32.Gen.Params.Admin.Params Evergreen.V32.Pages.Admin.Model
    | End Evergreen.V32.Gen.Params.End.Params Evergreen.V32.Pages.End.Model
    | Example Evergreen.V32.Gen.Params.Example.Params Evergreen.V32.Pages.Example.Model
    | Home_ Evergreen.V32.Gen.Params.Home_.Params Evergreen.V32.Pages.Home_.Model
    | Log Evergreen.V32.Gen.Params.Log.Params Evergreen.V32.Pages.Log.Model
    | Login Evergreen.V32.Gen.Params.Login.Params Evergreen.V32.Pages.Login.Model
    | NotFound Evergreen.V32.Gen.Params.NotFound.Params
    | Register Evergreen.V32.Gen.Params.Register.Params Evergreen.V32.Pages.Register.Model
    | Channel__Id_ Evergreen.V32.Gen.Params.Channel.Id_.Params Evergreen.V32.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V32.Gen.Params.Ga.Email_.Params Evergreen.V32.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V32.Gen.Params.Playlist.Id_.Params Evergreen.V32.Pages.Playlist.Id_.Model
