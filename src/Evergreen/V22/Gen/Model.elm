module Evergreen.V22.Gen.Model exposing (..)

import Evergreen.V22.Gen.Params.Admin
import Evergreen.V22.Gen.Params.Channel.Id_
import Evergreen.V22.Gen.Params.End
import Evergreen.V22.Gen.Params.Example
import Evergreen.V22.Gen.Params.Ga.Email_
import Evergreen.V22.Gen.Params.Home_
import Evergreen.V22.Gen.Params.Log
import Evergreen.V22.Gen.Params.Login
import Evergreen.V22.Gen.Params.NotFound
import Evergreen.V22.Gen.Params.Playlist.Id_
import Evergreen.V22.Gen.Params.Register
import Evergreen.V22.Pages.Admin
import Evergreen.V22.Pages.Channel.Id_
import Evergreen.V22.Pages.End
import Evergreen.V22.Pages.Example
import Evergreen.V22.Pages.Ga.Email_
import Evergreen.V22.Pages.Home_
import Evergreen.V22.Pages.Log
import Evergreen.V22.Pages.Login
import Evergreen.V22.Pages.Playlist.Id_
import Evergreen.V22.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V22.Gen.Params.Admin.Params Evergreen.V22.Pages.Admin.Model
    | End Evergreen.V22.Gen.Params.End.Params Evergreen.V22.Pages.End.Model
    | Example Evergreen.V22.Gen.Params.Example.Params Evergreen.V22.Pages.Example.Model
    | Home_ Evergreen.V22.Gen.Params.Home_.Params Evergreen.V22.Pages.Home_.Model
    | Log Evergreen.V22.Gen.Params.Log.Params Evergreen.V22.Pages.Log.Model
    | Login Evergreen.V22.Gen.Params.Login.Params Evergreen.V22.Pages.Login.Model
    | NotFound Evergreen.V22.Gen.Params.NotFound.Params
    | Register Evergreen.V22.Gen.Params.Register.Params Evergreen.V22.Pages.Register.Model
    | Channel__Id_ Evergreen.V22.Gen.Params.Channel.Id_.Params Evergreen.V22.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V22.Gen.Params.Ga.Email_.Params Evergreen.V22.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V22.Gen.Params.Playlist.Id_.Params Evergreen.V22.Pages.Playlist.Id_.Model
