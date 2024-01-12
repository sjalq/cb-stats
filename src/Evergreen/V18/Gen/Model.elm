module Evergreen.V18.Gen.Model exposing (..)

import Evergreen.V18.Gen.Params.Admin
import Evergreen.V18.Gen.Params.Channel.Id_
import Evergreen.V18.Gen.Params.End
import Evergreen.V18.Gen.Params.Example
import Evergreen.V18.Gen.Params.Ga.Email_
import Evergreen.V18.Gen.Params.Home_
import Evergreen.V18.Gen.Params.Log
import Evergreen.V18.Gen.Params.Login
import Evergreen.V18.Gen.Params.NotFound
import Evergreen.V18.Gen.Params.Playlist.Id_
import Evergreen.V18.Gen.Params.Register
import Evergreen.V18.Pages.Admin
import Evergreen.V18.Pages.Channel.Id_
import Evergreen.V18.Pages.End
import Evergreen.V18.Pages.Example
import Evergreen.V18.Pages.Ga.Email_
import Evergreen.V18.Pages.Home_
import Evergreen.V18.Pages.Log
import Evergreen.V18.Pages.Login
import Evergreen.V18.Pages.Playlist.Id_
import Evergreen.V18.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V18.Gen.Params.Admin.Params Evergreen.V18.Pages.Admin.Model
    | End Evergreen.V18.Gen.Params.End.Params Evergreen.V18.Pages.End.Model
    | Example Evergreen.V18.Gen.Params.Example.Params Evergreen.V18.Pages.Example.Model
    | Home_ Evergreen.V18.Gen.Params.Home_.Params Evergreen.V18.Pages.Home_.Model
    | Log Evergreen.V18.Gen.Params.Log.Params Evergreen.V18.Pages.Log.Model
    | Login Evergreen.V18.Gen.Params.Login.Params Evergreen.V18.Pages.Login.Model
    | NotFound Evergreen.V18.Gen.Params.NotFound.Params
    | Register Evergreen.V18.Gen.Params.Register.Params Evergreen.V18.Pages.Register.Model
    | Channel__Id_ Evergreen.V18.Gen.Params.Channel.Id_.Params Evergreen.V18.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V18.Gen.Params.Ga.Email_.Params Evergreen.V18.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V18.Gen.Params.Playlist.Id_.Params Evergreen.V18.Pages.Playlist.Id_.Model
