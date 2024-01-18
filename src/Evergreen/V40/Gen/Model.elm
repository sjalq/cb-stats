module Evergreen.V40.Gen.Model exposing (..)

import Evergreen.V40.Gen.Params.Admin
import Evergreen.V40.Gen.Params.Channel.Id_
import Evergreen.V40.Gen.Params.End
import Evergreen.V40.Gen.Params.Example
import Evergreen.V40.Gen.Params.Ga.Email_
import Evergreen.V40.Gen.Params.Home_
import Evergreen.V40.Gen.Params.Log
import Evergreen.V40.Gen.Params.Login
import Evergreen.V40.Gen.Params.NotFound
import Evergreen.V40.Gen.Params.Playlist.Id_
import Evergreen.V40.Gen.Params.Register
import Evergreen.V40.Gen.Params.Video.Id_
import Evergreen.V40.Pages.Admin
import Evergreen.V40.Pages.Channel.Id_
import Evergreen.V40.Pages.End
import Evergreen.V40.Pages.Example
import Evergreen.V40.Pages.Ga.Email_
import Evergreen.V40.Pages.Home_
import Evergreen.V40.Pages.Log
import Evergreen.V40.Pages.Login
import Evergreen.V40.Pages.Playlist.Id_
import Evergreen.V40.Pages.Register
import Evergreen.V40.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V40.Gen.Params.Admin.Params Evergreen.V40.Pages.Admin.Model
    | End Evergreen.V40.Gen.Params.End.Params Evergreen.V40.Pages.End.Model
    | Example Evergreen.V40.Gen.Params.Example.Params Evergreen.V40.Pages.Example.Model
    | Home_ Evergreen.V40.Gen.Params.Home_.Params Evergreen.V40.Pages.Home_.Model
    | Log Evergreen.V40.Gen.Params.Log.Params Evergreen.V40.Pages.Log.Model
    | Login Evergreen.V40.Gen.Params.Login.Params Evergreen.V40.Pages.Login.Model
    | NotFound Evergreen.V40.Gen.Params.NotFound.Params
    | Register Evergreen.V40.Gen.Params.Register.Params Evergreen.V40.Pages.Register.Model
    | Channel__Id_ Evergreen.V40.Gen.Params.Channel.Id_.Params Evergreen.V40.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V40.Gen.Params.Ga.Email_.Params Evergreen.V40.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V40.Gen.Params.Playlist.Id_.Params Evergreen.V40.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V40.Gen.Params.Video.Id_.Params Evergreen.V40.Pages.Video.Id_.Model
