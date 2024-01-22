module Evergreen.V54.Gen.Model exposing (..)

import Evergreen.V54.Gen.Params.Admin
import Evergreen.V54.Gen.Params.Channel.Id_
import Evergreen.V54.Gen.Params.End
import Evergreen.V54.Gen.Params.Example
import Evergreen.V54.Gen.Params.Ga.Email_
import Evergreen.V54.Gen.Params.Home_
import Evergreen.V54.Gen.Params.Log
import Evergreen.V54.Gen.Params.Login
import Evergreen.V54.Gen.Params.NotFound
import Evergreen.V54.Gen.Params.Playlist.Id_
import Evergreen.V54.Gen.Params.Register
import Evergreen.V54.Gen.Params.Video.Id_
import Evergreen.V54.Pages.Admin
import Evergreen.V54.Pages.Channel.Id_
import Evergreen.V54.Pages.End
import Evergreen.V54.Pages.Example
import Evergreen.V54.Pages.Ga.Email_
import Evergreen.V54.Pages.Home_
import Evergreen.V54.Pages.Log
import Evergreen.V54.Pages.Login
import Evergreen.V54.Pages.Playlist.Id_
import Evergreen.V54.Pages.Register
import Evergreen.V54.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V54.Gen.Params.Admin.Params Evergreen.V54.Pages.Admin.Model
    | End Evergreen.V54.Gen.Params.End.Params Evergreen.V54.Pages.End.Model
    | Example Evergreen.V54.Gen.Params.Example.Params Evergreen.V54.Pages.Example.Model
    | Home_ Evergreen.V54.Gen.Params.Home_.Params Evergreen.V54.Pages.Home_.Model
    | Log Evergreen.V54.Gen.Params.Log.Params Evergreen.V54.Pages.Log.Model
    | Login Evergreen.V54.Gen.Params.Login.Params Evergreen.V54.Pages.Login.Model
    | NotFound Evergreen.V54.Gen.Params.NotFound.Params
    | Register Evergreen.V54.Gen.Params.Register.Params Evergreen.V54.Pages.Register.Model
    | Channel__Id_ Evergreen.V54.Gen.Params.Channel.Id_.Params Evergreen.V54.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V54.Gen.Params.Ga.Email_.Params Evergreen.V54.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V54.Gen.Params.Playlist.Id_.Params Evergreen.V54.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V54.Gen.Params.Video.Id_.Params Evergreen.V54.Pages.Video.Id_.Model
