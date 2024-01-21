module Evergreen.V50.Gen.Model exposing (..)

import Evergreen.V50.Gen.Params.Admin
import Evergreen.V50.Gen.Params.Channel.Id_
import Evergreen.V50.Gen.Params.End
import Evergreen.V50.Gen.Params.Example
import Evergreen.V50.Gen.Params.Ga.Email_
import Evergreen.V50.Gen.Params.Home_
import Evergreen.V50.Gen.Params.Log
import Evergreen.V50.Gen.Params.Login
import Evergreen.V50.Gen.Params.NotFound
import Evergreen.V50.Gen.Params.Playlist.Id_
import Evergreen.V50.Gen.Params.Register
import Evergreen.V50.Gen.Params.Video.Id_
import Evergreen.V50.Pages.Admin
import Evergreen.V50.Pages.Channel.Id_
import Evergreen.V50.Pages.End
import Evergreen.V50.Pages.Example
import Evergreen.V50.Pages.Ga.Email_
import Evergreen.V50.Pages.Home_
import Evergreen.V50.Pages.Log
import Evergreen.V50.Pages.Login
import Evergreen.V50.Pages.Playlist.Id_
import Evergreen.V50.Pages.Register
import Evergreen.V50.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V50.Gen.Params.Admin.Params Evergreen.V50.Pages.Admin.Model
    | End Evergreen.V50.Gen.Params.End.Params Evergreen.V50.Pages.End.Model
    | Example Evergreen.V50.Gen.Params.Example.Params Evergreen.V50.Pages.Example.Model
    | Home_ Evergreen.V50.Gen.Params.Home_.Params Evergreen.V50.Pages.Home_.Model
    | Log Evergreen.V50.Gen.Params.Log.Params Evergreen.V50.Pages.Log.Model
    | Login Evergreen.V50.Gen.Params.Login.Params Evergreen.V50.Pages.Login.Model
    | NotFound Evergreen.V50.Gen.Params.NotFound.Params
    | Register Evergreen.V50.Gen.Params.Register.Params Evergreen.V50.Pages.Register.Model
    | Channel__Id_ Evergreen.V50.Gen.Params.Channel.Id_.Params Evergreen.V50.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V50.Gen.Params.Ga.Email_.Params Evergreen.V50.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V50.Gen.Params.Playlist.Id_.Params Evergreen.V50.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V50.Gen.Params.Video.Id_.Params Evergreen.V50.Pages.Video.Id_.Model
