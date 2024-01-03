module Evergreen.V11.Gen.Model exposing (..)

import Evergreen.V11.Gen.Params.Admin
import Evergreen.V11.Gen.Params.Channel.Id_
import Evergreen.V11.Gen.Params.End
import Evergreen.V11.Gen.Params.Example
import Evergreen.V11.Gen.Params.Ga.Email_
import Evergreen.V11.Gen.Params.Home_
import Evergreen.V11.Gen.Params.Log
import Evergreen.V11.Gen.Params.Login
import Evergreen.V11.Gen.Params.NotFound
import Evergreen.V11.Gen.Params.Playlist.Id_
import Evergreen.V11.Gen.Params.Register
import Evergreen.V11.Pages.Admin
import Evergreen.V11.Pages.Channel.Id_
import Evergreen.V11.Pages.End
import Evergreen.V11.Pages.Example
import Evergreen.V11.Pages.Ga.Email_
import Evergreen.V11.Pages.Home_
import Evergreen.V11.Pages.Log
import Evergreen.V11.Pages.Login
import Evergreen.V11.Pages.Playlist.Id_
import Evergreen.V11.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V11.Gen.Params.Admin.Params Evergreen.V11.Pages.Admin.Model
    | End Evergreen.V11.Gen.Params.End.Params Evergreen.V11.Pages.End.Model
    | Example Evergreen.V11.Gen.Params.Example.Params Evergreen.V11.Pages.Example.Model
    | Home_ Evergreen.V11.Gen.Params.Home_.Params Evergreen.V11.Pages.Home_.Model
    | Log Evergreen.V11.Gen.Params.Log.Params Evergreen.V11.Pages.Log.Model
    | Login Evergreen.V11.Gen.Params.Login.Params Evergreen.V11.Pages.Login.Model
    | NotFound Evergreen.V11.Gen.Params.NotFound.Params
    | Register Evergreen.V11.Gen.Params.Register.Params Evergreen.V11.Pages.Register.Model
    | Channel__Id_ Evergreen.V11.Gen.Params.Channel.Id_.Params Evergreen.V11.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V11.Gen.Params.Ga.Email_.Params Evergreen.V11.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V11.Gen.Params.Playlist.Id_.Params Evergreen.V11.Pages.Playlist.Id_.Model
