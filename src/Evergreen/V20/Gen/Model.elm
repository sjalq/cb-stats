module Evergreen.V20.Gen.Model exposing (..)

import Evergreen.V20.Gen.Params.Admin
import Evergreen.V20.Gen.Params.Channel.Id_
import Evergreen.V20.Gen.Params.End
import Evergreen.V20.Gen.Params.Example
import Evergreen.V20.Gen.Params.Ga.Email_
import Evergreen.V20.Gen.Params.Home_
import Evergreen.V20.Gen.Params.Log
import Evergreen.V20.Gen.Params.Login
import Evergreen.V20.Gen.Params.NotFound
import Evergreen.V20.Gen.Params.Playlist.Id_
import Evergreen.V20.Gen.Params.Register
import Evergreen.V20.Pages.Admin
import Evergreen.V20.Pages.Channel.Id_
import Evergreen.V20.Pages.End
import Evergreen.V20.Pages.Example
import Evergreen.V20.Pages.Ga.Email_
import Evergreen.V20.Pages.Home_
import Evergreen.V20.Pages.Log
import Evergreen.V20.Pages.Login
import Evergreen.V20.Pages.Playlist.Id_
import Evergreen.V20.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V20.Gen.Params.Admin.Params Evergreen.V20.Pages.Admin.Model
    | End Evergreen.V20.Gen.Params.End.Params Evergreen.V20.Pages.End.Model
    | Example Evergreen.V20.Gen.Params.Example.Params Evergreen.V20.Pages.Example.Model
    | Home_ Evergreen.V20.Gen.Params.Home_.Params Evergreen.V20.Pages.Home_.Model
    | Log Evergreen.V20.Gen.Params.Log.Params Evergreen.V20.Pages.Log.Model
    | Login Evergreen.V20.Gen.Params.Login.Params Evergreen.V20.Pages.Login.Model
    | NotFound Evergreen.V20.Gen.Params.NotFound.Params
    | Register Evergreen.V20.Gen.Params.Register.Params Evergreen.V20.Pages.Register.Model
    | Channel__Id_ Evergreen.V20.Gen.Params.Channel.Id_.Params Evergreen.V20.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V20.Gen.Params.Ga.Email_.Params Evergreen.V20.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V20.Gen.Params.Playlist.Id_.Params Evergreen.V20.Pages.Playlist.Id_.Model
