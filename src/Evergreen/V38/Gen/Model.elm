module Evergreen.V38.Gen.Model exposing (..)

import Evergreen.V38.Gen.Params.Admin
import Evergreen.V38.Gen.Params.Channel.Id_
import Evergreen.V38.Gen.Params.End
import Evergreen.V38.Gen.Params.Example
import Evergreen.V38.Gen.Params.Ga.Email_
import Evergreen.V38.Gen.Params.Home_
import Evergreen.V38.Gen.Params.Log
import Evergreen.V38.Gen.Params.Login
import Evergreen.V38.Gen.Params.NotFound
import Evergreen.V38.Gen.Params.Playlist.Id_
import Evergreen.V38.Gen.Params.Register
import Evergreen.V38.Pages.Admin
import Evergreen.V38.Pages.Channel.Id_
import Evergreen.V38.Pages.End
import Evergreen.V38.Pages.Example
import Evergreen.V38.Pages.Ga.Email_
import Evergreen.V38.Pages.Home_
import Evergreen.V38.Pages.Log
import Evergreen.V38.Pages.Login
import Evergreen.V38.Pages.Playlist.Id_
import Evergreen.V38.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V38.Gen.Params.Admin.Params Evergreen.V38.Pages.Admin.Model
    | End Evergreen.V38.Gen.Params.End.Params Evergreen.V38.Pages.End.Model
    | Example Evergreen.V38.Gen.Params.Example.Params Evergreen.V38.Pages.Example.Model
    | Home_ Evergreen.V38.Gen.Params.Home_.Params Evergreen.V38.Pages.Home_.Model
    | Log Evergreen.V38.Gen.Params.Log.Params Evergreen.V38.Pages.Log.Model
    | Login Evergreen.V38.Gen.Params.Login.Params Evergreen.V38.Pages.Login.Model
    | NotFound Evergreen.V38.Gen.Params.NotFound.Params
    | Register Evergreen.V38.Gen.Params.Register.Params Evergreen.V38.Pages.Register.Model
    | Channel__Id_ Evergreen.V38.Gen.Params.Channel.Id_.Params Evergreen.V38.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V38.Gen.Params.Ga.Email_.Params Evergreen.V38.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V38.Gen.Params.Playlist.Id_.Params Evergreen.V38.Pages.Playlist.Id_.Model
