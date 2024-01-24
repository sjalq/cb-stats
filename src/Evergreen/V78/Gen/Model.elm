module Evergreen.V78.Gen.Model exposing (..)

import Evergreen.V78.Gen.Params.Admin
import Evergreen.V78.Gen.Params.Channel.Id_
import Evergreen.V78.Gen.Params.End
import Evergreen.V78.Gen.Params.Example
import Evergreen.V78.Gen.Params.Ga.Email_
import Evergreen.V78.Gen.Params.Home_
import Evergreen.V78.Gen.Params.Log
import Evergreen.V78.Gen.Params.Login
import Evergreen.V78.Gen.Params.NotFound
import Evergreen.V78.Gen.Params.Playlist.Id_
import Evergreen.V78.Gen.Params.Register
import Evergreen.V78.Gen.Params.Video.Id_
import Evergreen.V78.Pages.Admin
import Evergreen.V78.Pages.Channel.Id_
import Evergreen.V78.Pages.End
import Evergreen.V78.Pages.Example
import Evergreen.V78.Pages.Ga.Email_
import Evergreen.V78.Pages.Home_
import Evergreen.V78.Pages.Log
import Evergreen.V78.Pages.Login
import Evergreen.V78.Pages.Playlist.Id_
import Evergreen.V78.Pages.Register
import Evergreen.V78.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V78.Gen.Params.Admin.Params Evergreen.V78.Pages.Admin.Model
    | End Evergreen.V78.Gen.Params.End.Params Evergreen.V78.Pages.End.Model
    | Example Evergreen.V78.Gen.Params.Example.Params Evergreen.V78.Pages.Example.Model
    | Home_ Evergreen.V78.Gen.Params.Home_.Params Evergreen.V78.Pages.Home_.Model
    | Log Evergreen.V78.Gen.Params.Log.Params Evergreen.V78.Pages.Log.Model
    | Login Evergreen.V78.Gen.Params.Login.Params Evergreen.V78.Pages.Login.Model
    | NotFound Evergreen.V78.Gen.Params.NotFound.Params
    | Register Evergreen.V78.Gen.Params.Register.Params Evergreen.V78.Pages.Register.Model
    | Channel__Id_ Evergreen.V78.Gen.Params.Channel.Id_.Params Evergreen.V78.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V78.Gen.Params.Ga.Email_.Params Evergreen.V78.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V78.Gen.Params.Playlist.Id_.Params Evergreen.V78.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V78.Gen.Params.Video.Id_.Params Evergreen.V78.Pages.Video.Id_.Model
