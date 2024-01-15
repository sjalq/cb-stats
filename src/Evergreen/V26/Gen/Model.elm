module Evergreen.V26.Gen.Model exposing (..)

import Evergreen.V26.Gen.Params.Admin
import Evergreen.V26.Gen.Params.Channel.Id_
import Evergreen.V26.Gen.Params.End
import Evergreen.V26.Gen.Params.Example
import Evergreen.V26.Gen.Params.Ga.Email_
import Evergreen.V26.Gen.Params.Home_
import Evergreen.V26.Gen.Params.Log
import Evergreen.V26.Gen.Params.Login
import Evergreen.V26.Gen.Params.NotFound
import Evergreen.V26.Gen.Params.Playlist.Id_
import Evergreen.V26.Gen.Params.Register
import Evergreen.V26.Pages.Admin
import Evergreen.V26.Pages.Channel.Id_
import Evergreen.V26.Pages.End
import Evergreen.V26.Pages.Example
import Evergreen.V26.Pages.Ga.Email_
import Evergreen.V26.Pages.Home_
import Evergreen.V26.Pages.Log
import Evergreen.V26.Pages.Login
import Evergreen.V26.Pages.Playlist.Id_
import Evergreen.V26.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V26.Gen.Params.Admin.Params Evergreen.V26.Pages.Admin.Model
    | End Evergreen.V26.Gen.Params.End.Params Evergreen.V26.Pages.End.Model
    | Example Evergreen.V26.Gen.Params.Example.Params Evergreen.V26.Pages.Example.Model
    | Home_ Evergreen.V26.Gen.Params.Home_.Params Evergreen.V26.Pages.Home_.Model
    | Log Evergreen.V26.Gen.Params.Log.Params Evergreen.V26.Pages.Log.Model
    | Login Evergreen.V26.Gen.Params.Login.Params Evergreen.V26.Pages.Login.Model
    | NotFound Evergreen.V26.Gen.Params.NotFound.Params
    | Register Evergreen.V26.Gen.Params.Register.Params Evergreen.V26.Pages.Register.Model
    | Channel__Id_ Evergreen.V26.Gen.Params.Channel.Id_.Params Evergreen.V26.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V26.Gen.Params.Ga.Email_.Params Evergreen.V26.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V26.Gen.Params.Playlist.Id_.Params Evergreen.V26.Pages.Playlist.Id_.Model
