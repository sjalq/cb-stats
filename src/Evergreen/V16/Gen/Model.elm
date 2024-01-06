module Evergreen.V16.Gen.Model exposing (..)

import Evergreen.V16.Gen.Params.Admin
import Evergreen.V16.Gen.Params.Channel.Id_
import Evergreen.V16.Gen.Params.End
import Evergreen.V16.Gen.Params.Example
import Evergreen.V16.Gen.Params.Ga.Email_
import Evergreen.V16.Gen.Params.Home_
import Evergreen.V16.Gen.Params.Log
import Evergreen.V16.Gen.Params.Login
import Evergreen.V16.Gen.Params.NotFound
import Evergreen.V16.Gen.Params.Playlist.Id_
import Evergreen.V16.Gen.Params.Register
import Evergreen.V16.Pages.Admin
import Evergreen.V16.Pages.Channel.Id_
import Evergreen.V16.Pages.End
import Evergreen.V16.Pages.Example
import Evergreen.V16.Pages.Ga.Email_
import Evergreen.V16.Pages.Home_
import Evergreen.V16.Pages.Log
import Evergreen.V16.Pages.Login
import Evergreen.V16.Pages.Playlist.Id_
import Evergreen.V16.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V16.Gen.Params.Admin.Params Evergreen.V16.Pages.Admin.Model
    | End Evergreen.V16.Gen.Params.End.Params Evergreen.V16.Pages.End.Model
    | Example Evergreen.V16.Gen.Params.Example.Params Evergreen.V16.Pages.Example.Model
    | Home_ Evergreen.V16.Gen.Params.Home_.Params Evergreen.V16.Pages.Home_.Model
    | Log Evergreen.V16.Gen.Params.Log.Params Evergreen.V16.Pages.Log.Model
    | Login Evergreen.V16.Gen.Params.Login.Params Evergreen.V16.Pages.Login.Model
    | NotFound Evergreen.V16.Gen.Params.NotFound.Params
    | Register Evergreen.V16.Gen.Params.Register.Params Evergreen.V16.Pages.Register.Model
    | Channel__Id_ Evergreen.V16.Gen.Params.Channel.Id_.Params Evergreen.V16.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V16.Gen.Params.Ga.Email_.Params Evergreen.V16.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V16.Gen.Params.Playlist.Id_.Params Evergreen.V16.Pages.Playlist.Id_.Model
