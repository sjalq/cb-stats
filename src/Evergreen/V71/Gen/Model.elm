module Evergreen.V71.Gen.Model exposing (..)

import Evergreen.V71.Gen.Params.Admin
import Evergreen.V71.Gen.Params.Channel.Id_
import Evergreen.V71.Gen.Params.End
import Evergreen.V71.Gen.Params.Example
import Evergreen.V71.Gen.Params.Ga.Email_
import Evergreen.V71.Gen.Params.Home_
import Evergreen.V71.Gen.Params.Log
import Evergreen.V71.Gen.Params.Login
import Evergreen.V71.Gen.Params.NotFound
import Evergreen.V71.Gen.Params.Playlist.Id_
import Evergreen.V71.Gen.Params.Register
import Evergreen.V71.Gen.Params.Video.Id_
import Evergreen.V71.Pages.Admin
import Evergreen.V71.Pages.Channel.Id_
import Evergreen.V71.Pages.End
import Evergreen.V71.Pages.Example
import Evergreen.V71.Pages.Ga.Email_
import Evergreen.V71.Pages.Home_
import Evergreen.V71.Pages.Log
import Evergreen.V71.Pages.Login
import Evergreen.V71.Pages.Playlist.Id_
import Evergreen.V71.Pages.Register
import Evergreen.V71.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V71.Gen.Params.Admin.Params Evergreen.V71.Pages.Admin.Model
    | End Evergreen.V71.Gen.Params.End.Params Evergreen.V71.Pages.End.Model
    | Example Evergreen.V71.Gen.Params.Example.Params Evergreen.V71.Pages.Example.Model
    | Home_ Evergreen.V71.Gen.Params.Home_.Params Evergreen.V71.Pages.Home_.Model
    | Log Evergreen.V71.Gen.Params.Log.Params Evergreen.V71.Pages.Log.Model
    | Login Evergreen.V71.Gen.Params.Login.Params Evergreen.V71.Pages.Login.Model
    | NotFound Evergreen.V71.Gen.Params.NotFound.Params
    | Register Evergreen.V71.Gen.Params.Register.Params Evergreen.V71.Pages.Register.Model
    | Channel__Id_ Evergreen.V71.Gen.Params.Channel.Id_.Params Evergreen.V71.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V71.Gen.Params.Ga.Email_.Params Evergreen.V71.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V71.Gen.Params.Playlist.Id_.Params Evergreen.V71.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V71.Gen.Params.Video.Id_.Params Evergreen.V71.Pages.Video.Id_.Model
