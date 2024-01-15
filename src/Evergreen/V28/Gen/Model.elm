module Evergreen.V28.Gen.Model exposing (..)

import Evergreen.V28.Gen.Params.Admin
import Evergreen.V28.Gen.Params.Channel.Id_
import Evergreen.V28.Gen.Params.End
import Evergreen.V28.Gen.Params.Example
import Evergreen.V28.Gen.Params.Ga.Email_
import Evergreen.V28.Gen.Params.Home_
import Evergreen.V28.Gen.Params.Log
import Evergreen.V28.Gen.Params.Login
import Evergreen.V28.Gen.Params.NotFound
import Evergreen.V28.Gen.Params.Playlist.Id_
import Evergreen.V28.Gen.Params.Register
import Evergreen.V28.Pages.Admin
import Evergreen.V28.Pages.Channel.Id_
import Evergreen.V28.Pages.End
import Evergreen.V28.Pages.Example
import Evergreen.V28.Pages.Ga.Email_
import Evergreen.V28.Pages.Home_
import Evergreen.V28.Pages.Log
import Evergreen.V28.Pages.Login
import Evergreen.V28.Pages.Playlist.Id_
import Evergreen.V28.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V28.Gen.Params.Admin.Params Evergreen.V28.Pages.Admin.Model
    | End Evergreen.V28.Gen.Params.End.Params Evergreen.V28.Pages.End.Model
    | Example Evergreen.V28.Gen.Params.Example.Params Evergreen.V28.Pages.Example.Model
    | Home_ Evergreen.V28.Gen.Params.Home_.Params Evergreen.V28.Pages.Home_.Model
    | Log Evergreen.V28.Gen.Params.Log.Params Evergreen.V28.Pages.Log.Model
    | Login Evergreen.V28.Gen.Params.Login.Params Evergreen.V28.Pages.Login.Model
    | NotFound Evergreen.V28.Gen.Params.NotFound.Params
    | Register Evergreen.V28.Gen.Params.Register.Params Evergreen.V28.Pages.Register.Model
    | Channel__Id_ Evergreen.V28.Gen.Params.Channel.Id_.Params Evergreen.V28.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V28.Gen.Params.Ga.Email_.Params Evergreen.V28.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V28.Gen.Params.Playlist.Id_.Params Evergreen.V28.Pages.Playlist.Id_.Model
