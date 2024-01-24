module Evergreen.V77.Gen.Model exposing (..)

import Evergreen.V77.Gen.Params.Admin
import Evergreen.V77.Gen.Params.Channel.Id_
import Evergreen.V77.Gen.Params.End
import Evergreen.V77.Gen.Params.Example
import Evergreen.V77.Gen.Params.Ga.Email_
import Evergreen.V77.Gen.Params.Home_
import Evergreen.V77.Gen.Params.Log
import Evergreen.V77.Gen.Params.Login
import Evergreen.V77.Gen.Params.NotFound
import Evergreen.V77.Gen.Params.Playlist.Id_
import Evergreen.V77.Gen.Params.Register
import Evergreen.V77.Gen.Params.Video.Id_
import Evergreen.V77.Pages.Admin
import Evergreen.V77.Pages.Channel.Id_
import Evergreen.V77.Pages.End
import Evergreen.V77.Pages.Example
import Evergreen.V77.Pages.Ga.Email_
import Evergreen.V77.Pages.Home_
import Evergreen.V77.Pages.Log
import Evergreen.V77.Pages.Login
import Evergreen.V77.Pages.Playlist.Id_
import Evergreen.V77.Pages.Register
import Evergreen.V77.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V77.Gen.Params.Admin.Params Evergreen.V77.Pages.Admin.Model
    | End Evergreen.V77.Gen.Params.End.Params Evergreen.V77.Pages.End.Model
    | Example Evergreen.V77.Gen.Params.Example.Params Evergreen.V77.Pages.Example.Model
    | Home_ Evergreen.V77.Gen.Params.Home_.Params Evergreen.V77.Pages.Home_.Model
    | Log Evergreen.V77.Gen.Params.Log.Params Evergreen.V77.Pages.Log.Model
    | Login Evergreen.V77.Gen.Params.Login.Params Evergreen.V77.Pages.Login.Model
    | NotFound Evergreen.V77.Gen.Params.NotFound.Params
    | Register Evergreen.V77.Gen.Params.Register.Params Evergreen.V77.Pages.Register.Model
    | Channel__Id_ Evergreen.V77.Gen.Params.Channel.Id_.Params Evergreen.V77.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V77.Gen.Params.Ga.Email_.Params Evergreen.V77.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V77.Gen.Params.Playlist.Id_.Params Evergreen.V77.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V77.Gen.Params.Video.Id_.Params Evergreen.V77.Pages.Video.Id_.Model
