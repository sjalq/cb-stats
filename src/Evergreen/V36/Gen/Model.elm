module Evergreen.V36.Gen.Model exposing (..)

import Evergreen.V36.Gen.Params.Admin
import Evergreen.V36.Gen.Params.Channel.Id_
import Evergreen.V36.Gen.Params.End
import Evergreen.V36.Gen.Params.Example
import Evergreen.V36.Gen.Params.Ga.Email_
import Evergreen.V36.Gen.Params.Home_
import Evergreen.V36.Gen.Params.Log
import Evergreen.V36.Gen.Params.Login
import Evergreen.V36.Gen.Params.NotFound
import Evergreen.V36.Gen.Params.Playlist.Id_
import Evergreen.V36.Gen.Params.Register
import Evergreen.V36.Pages.Admin
import Evergreen.V36.Pages.Channel.Id_
import Evergreen.V36.Pages.End
import Evergreen.V36.Pages.Example
import Evergreen.V36.Pages.Ga.Email_
import Evergreen.V36.Pages.Home_
import Evergreen.V36.Pages.Log
import Evergreen.V36.Pages.Login
import Evergreen.V36.Pages.Playlist.Id_
import Evergreen.V36.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V36.Gen.Params.Admin.Params Evergreen.V36.Pages.Admin.Model
    | End Evergreen.V36.Gen.Params.End.Params Evergreen.V36.Pages.End.Model
    | Example Evergreen.V36.Gen.Params.Example.Params Evergreen.V36.Pages.Example.Model
    | Home_ Evergreen.V36.Gen.Params.Home_.Params Evergreen.V36.Pages.Home_.Model
    | Log Evergreen.V36.Gen.Params.Log.Params Evergreen.V36.Pages.Log.Model
    | Login Evergreen.V36.Gen.Params.Login.Params Evergreen.V36.Pages.Login.Model
    | NotFound Evergreen.V36.Gen.Params.NotFound.Params
    | Register Evergreen.V36.Gen.Params.Register.Params Evergreen.V36.Pages.Register.Model
    | Channel__Id_ Evergreen.V36.Gen.Params.Channel.Id_.Params Evergreen.V36.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V36.Gen.Params.Ga.Email_.Params Evergreen.V36.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V36.Gen.Params.Playlist.Id_.Params Evergreen.V36.Pages.Playlist.Id_.Model
