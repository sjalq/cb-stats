module Evergreen.V51.Gen.Model exposing (..)

import Evergreen.V51.Gen.Params.Admin
import Evergreen.V51.Gen.Params.Channel.Id_
import Evergreen.V51.Gen.Params.End
import Evergreen.V51.Gen.Params.Example
import Evergreen.V51.Gen.Params.Ga.Email_
import Evergreen.V51.Gen.Params.Home_
import Evergreen.V51.Gen.Params.Log
import Evergreen.V51.Gen.Params.Login
import Evergreen.V51.Gen.Params.NotFound
import Evergreen.V51.Gen.Params.Playlist.Id_
import Evergreen.V51.Gen.Params.Register
import Evergreen.V51.Gen.Params.Video.Id_
import Evergreen.V51.Pages.Admin
import Evergreen.V51.Pages.Channel.Id_
import Evergreen.V51.Pages.End
import Evergreen.V51.Pages.Example
import Evergreen.V51.Pages.Ga.Email_
import Evergreen.V51.Pages.Home_
import Evergreen.V51.Pages.Log
import Evergreen.V51.Pages.Login
import Evergreen.V51.Pages.Playlist.Id_
import Evergreen.V51.Pages.Register
import Evergreen.V51.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V51.Gen.Params.Admin.Params Evergreen.V51.Pages.Admin.Model
    | End Evergreen.V51.Gen.Params.End.Params Evergreen.V51.Pages.End.Model
    | Example Evergreen.V51.Gen.Params.Example.Params Evergreen.V51.Pages.Example.Model
    | Home_ Evergreen.V51.Gen.Params.Home_.Params Evergreen.V51.Pages.Home_.Model
    | Log Evergreen.V51.Gen.Params.Log.Params Evergreen.V51.Pages.Log.Model
    | Login Evergreen.V51.Gen.Params.Login.Params Evergreen.V51.Pages.Login.Model
    | NotFound Evergreen.V51.Gen.Params.NotFound.Params
    | Register Evergreen.V51.Gen.Params.Register.Params Evergreen.V51.Pages.Register.Model
    | Channel__Id_ Evergreen.V51.Gen.Params.Channel.Id_.Params Evergreen.V51.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V51.Gen.Params.Ga.Email_.Params Evergreen.V51.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V51.Gen.Params.Playlist.Id_.Params Evergreen.V51.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V51.Gen.Params.Video.Id_.Params Evergreen.V51.Pages.Video.Id_.Model
