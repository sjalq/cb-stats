module Evergreen.V94.Gen.Model exposing (..)

import Evergreen.V94.Gen.Params.Admin
import Evergreen.V94.Gen.Params.Channel.Id_
import Evergreen.V94.Gen.Params.End
import Evergreen.V94.Gen.Params.Example
import Evergreen.V94.Gen.Params.Ga.Email_
import Evergreen.V94.Gen.Params.Home_
import Evergreen.V94.Gen.Params.Log
import Evergreen.V94.Gen.Params.Login
import Evergreen.V94.Gen.Params.NotFound
import Evergreen.V94.Gen.Params.Playlist.Id_
import Evergreen.V94.Gen.Params.Register
import Evergreen.V94.Gen.Params.Video.Id_
import Evergreen.V94.Pages.Admin
import Evergreen.V94.Pages.Channel.Id_
import Evergreen.V94.Pages.End
import Evergreen.V94.Pages.Example
import Evergreen.V94.Pages.Ga.Email_
import Evergreen.V94.Pages.Home_
import Evergreen.V94.Pages.Log
import Evergreen.V94.Pages.Login
import Evergreen.V94.Pages.Playlist.Id_
import Evergreen.V94.Pages.Register
import Evergreen.V94.Pages.Video.Id_


type Model
    = Redirecting_
    | Admin Evergreen.V94.Gen.Params.Admin.Params Evergreen.V94.Pages.Admin.Model
    | End Evergreen.V94.Gen.Params.End.Params Evergreen.V94.Pages.End.Model
    | Example Evergreen.V94.Gen.Params.Example.Params Evergreen.V94.Pages.Example.Model
    | Home_ Evergreen.V94.Gen.Params.Home_.Params Evergreen.V94.Pages.Home_.Model
    | Log Evergreen.V94.Gen.Params.Log.Params Evergreen.V94.Pages.Log.Model
    | Login Evergreen.V94.Gen.Params.Login.Params Evergreen.V94.Pages.Login.Model
    | NotFound Evergreen.V94.Gen.Params.NotFound.Params
    | Register Evergreen.V94.Gen.Params.Register.Params Evergreen.V94.Pages.Register.Model
    | Channel__Id_ Evergreen.V94.Gen.Params.Channel.Id_.Params Evergreen.V94.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V94.Gen.Params.Ga.Email_.Params Evergreen.V94.Pages.Ga.Email_.Model
    | Playlist__Id_ Evergreen.V94.Gen.Params.Playlist.Id_.Params Evergreen.V94.Pages.Playlist.Id_.Model
    | Video__Id_ Evergreen.V94.Gen.Params.Video.Id_.Params Evergreen.V94.Pages.Video.Id_.Model
