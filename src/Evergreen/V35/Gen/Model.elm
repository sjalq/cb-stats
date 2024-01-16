module Evergreen.V35.Gen.Model exposing (..)

import Evergreen.V35.Gen.Params.Admin
import Evergreen.V35.Gen.Params.Channel.Id_
import Evergreen.V35.Gen.Params.End
import Evergreen.V35.Gen.Params.Example
import Evergreen.V35.Gen.Params.Ga.Email_
import Evergreen.V35.Gen.Params.Home_
import Evergreen.V35.Gen.Params.Log
import Evergreen.V35.Gen.Params.Login
import Evergreen.V35.Gen.Params.NotFound
import Evergreen.V35.Gen.Params.Playlist.Id_
import Evergreen.V35.Gen.Params.Register
import Evergreen.V35.Pages.Admin
import Evergreen.V35.Pages.Channel.Id_
import Evergreen.V35.Pages.End
import Evergreen.V35.Pages.Example
import Evergreen.V35.Pages.Ga.Email_
import Evergreen.V35.Pages.Home_
import Evergreen.V35.Pages.Log
import Evergreen.V35.Pages.Login
import Evergreen.V35.Pages.Playlist.Id_
import Evergreen.V35.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V35.Gen.Params.Admin.Params Evergreen.V35.Pages.Admin.Model
    | End Evergreen.V35.Gen.Params.End.Params Evergreen.V35.Pages.End.Model
    | Example Evergreen.V35.Gen.Params.Example.Params Evergreen.V35.Pages.Example.Model
    | Home_ Evergreen.V35.Gen.Params.Home_.Params Evergreen.V35.Pages.Home_.Model
    | Log Evergreen.V35.Gen.Params.Log.Params Evergreen.V35.Pages.Log.Model
    | Login Evergreen.V35.Gen.Params.Login.Params Evergreen.V35.Pages.Login.Model
    | NotFound Evergreen.V35.Gen.Params.NotFound.Params
    | Register Evergreen.V35.Gen.Params.Register.Params Evergreen.V35.Pages.Register.Model
    | Channel__Id_ Evergreen.V35.Gen.Params.Channel.Id_.Params Evergreen.V35.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V35.Gen.Params.Ga.Email_.Params Evergreen.V35.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V35.Gen.Params.Playlist.Id_.Params Evergreen.V35.Pages.Playlist.Id_.Model
