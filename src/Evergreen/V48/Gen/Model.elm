module Evergreen.V48.Gen.Model exposing (..)

import Evergreen.V48.Gen.Params.Admin
import Evergreen.V48.Gen.Params.Channel.Id_
import Evergreen.V48.Gen.Params.End
import Evergreen.V48.Gen.Params.Example
import Evergreen.V48.Gen.Params.Ga.Email_
import Evergreen.V48.Gen.Params.Home_
import Evergreen.V48.Gen.Params.Log
import Evergreen.V48.Gen.Params.Login
import Evergreen.V48.Gen.Params.NotFound
import Evergreen.V48.Gen.Params.Playlist.Id_
import Evergreen.V48.Gen.Params.Register
import Evergreen.V48.Gen.Params.Video.Id_
import Evergreen.V48.Pages.Admin
import Evergreen.V48.Pages.Channel.Id_
import Evergreen.V48.Pages.End
import Evergreen.V48.Pages.Example
import Evergreen.V48.Pages.Ga.Email_
import Evergreen.V48.Pages.Home_
import Evergreen.V48.Pages.Log
import Evergreen.V48.Pages.Login
import Evergreen.V48.Pages.Playlist.Id_
import Evergreen.V48.Pages.Register
import Evergreen.V48.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V48.Gen.Params.Admin.Params Evergreen.V48.Pages.Admin.Model
    | End Evergreen.V48.Gen.Params.End.Params Evergreen.V48.Pages.End.Model
    | Example Evergreen.V48.Gen.Params.Example.Params Evergreen.V48.Pages.Example.Model
    | Home_ Evergreen.V48.Gen.Params.Home_.Params Evergreen.V48.Pages.Home_.Model
    | Log Evergreen.V48.Gen.Params.Log.Params Evergreen.V48.Pages.Log.Model
    | Login Evergreen.V48.Gen.Params.Login.Params Evergreen.V48.Pages.Login.Model
    | NotFound Evergreen.V48.Gen.Params.NotFound.Params
    | Register Evergreen.V48.Gen.Params.Register.Params Evergreen.V48.Pages.Register.Model
    | Channel__Id_ Evergreen.V48.Gen.Params.Channel.Id_.Params Evergreen.V48.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V48.Gen.Params.Ga.Email_.Params Evergreen.V48.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V48.Gen.Params.Playlist.Id_.Params Evergreen.V48.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V48.Gen.Params.Video.Id_.Params Evergreen.V48.Pages.Video.Id_.Model
