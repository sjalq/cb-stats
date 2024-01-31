module Evergreen.V138.Gen.Model exposing (..)

import Evergreen.V138.Gen.Params.Admin
import Evergreen.V138.Gen.Params.Channel.Id_
import Evergreen.V138.Gen.Params.End
import Evergreen.V138.Gen.Params.Example
import Evergreen.V138.Gen.Params.Ga.Email_
import Evergreen.V138.Gen.Params.Home_
import Evergreen.V138.Gen.Params.Log
import Evergreen.V138.Gen.Params.Login
import Evergreen.V138.Gen.Params.NotFound
import Evergreen.V138.Gen.Params.Playlist.Id_
import Evergreen.V138.Gen.Params.Register
import Evergreen.V138.Gen.Params.Video.Id_
import Evergreen.V138.Pages.Admin
import Evergreen.V138.Pages.Channel.Id_
import Evergreen.V138.Pages.End
import Evergreen.V138.Pages.Example
import Evergreen.V138.Pages.Ga.Email_
import Evergreen.V138.Pages.Home_
import Evergreen.V138.Pages.Log
import Evergreen.V138.Pages.Login
import Evergreen.V138.Pages.Playlist.Id_
import Evergreen.V138.Pages.Register
import Evergreen.V138.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V138.Gen.Params.Admin.Params Evergreen.V138.Pages.Admin.Model
    | End Evergreen.V138.Gen.Params.End.Params Evergreen.V138.Pages.End.Model
    | Example Evergreen.V138.Gen.Params.Example.Params Evergreen.V138.Pages.Example.Model
    | Home_ Evergreen.V138.Gen.Params.Home_.Params Evergreen.V138.Pages.Home_.Model
    | Log Evergreen.V138.Gen.Params.Log.Params Evergreen.V138.Pages.Log.Model
    | Login Evergreen.V138.Gen.Params.Login.Params Evergreen.V138.Pages.Login.Model
    | NotFound Evergreen.V138.Gen.Params.NotFound.Params
    | Register Evergreen.V138.Gen.Params.Register.Params Evergreen.V138.Pages.Register.Model
    | Channel__Id_ Evergreen.V138.Gen.Params.Channel.Id_.Params Evergreen.V138.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V138.Gen.Params.Ga.Email_.Params Evergreen.V138.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V138.Gen.Params.Playlist.Id_.Params Evergreen.V138.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V138.Gen.Params.Video.Id_.Params Evergreen.V138.Pages.Video.Id_.Model
