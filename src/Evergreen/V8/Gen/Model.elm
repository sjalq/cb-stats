module Evergreen.V8.Gen.Model exposing (..)

import Evergreen.V8.Gen.Params.Admin
import Evergreen.V8.Gen.Params.Channel.Id_
import Evergreen.V8.Gen.Params.End
import Evergreen.V8.Gen.Params.Example
import Evergreen.V8.Gen.Params.Ga.Email_
import Evergreen.V8.Gen.Params.Home_
import Evergreen.V8.Gen.Params.Log
import Evergreen.V8.Gen.Params.Login
import Evergreen.V8.Gen.Params.NotFound
import Evergreen.V8.Gen.Params.Playlist.Id_
import Evergreen.V8.Gen.Params.Register
import Evergreen.V8.Pages.Admin
import Evergreen.V8.Pages.Channel.Id_
import Evergreen.V8.Pages.End
import Evergreen.V8.Pages.Example
import Evergreen.V8.Pages.Ga.Email_
import Evergreen.V8.Pages.Home_
import Evergreen.V8.Pages.Log
import Evergreen.V8.Pages.Login
import Evergreen.V8.Pages.Playlist.Id_
import Evergreen.V8.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V8.Gen.Params.Admin.Params Evergreen.V8.Pages.Admin.Model
    | End Evergreen.V8.Gen.Params.End.Params Evergreen.V8.Pages.End.Model
    | Example Evergreen.V8.Gen.Params.Example.Params Evergreen.V8.Pages.Example.Model
    | Home_ Evergreen.V8.Gen.Params.Home_.Params Evergreen.V8.Pages.Home_.Model
    | Log Evergreen.V8.Gen.Params.Log.Params Evergreen.V8.Pages.Log.Model
    | Login Evergreen.V8.Gen.Params.Login.Params Evergreen.V8.Pages.Login.Model
    | NotFound Evergreen.V8.Gen.Params.NotFound.Params
    | Register Evergreen.V8.Gen.Params.Register.Params Evergreen.V8.Pages.Register.Model
    | Channel__Id_ Evergreen.V8.Gen.Params.Channel.Id_.Params Evergreen.V8.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V8.Gen.Params.Ga.Email_.Params Evergreen.V8.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V8.Gen.Params.Playlist.Id_.Params Evergreen.V8.Pages.Playlist.Id_.Model
