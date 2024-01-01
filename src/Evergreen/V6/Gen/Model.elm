module Evergreen.V6.Gen.Model exposing (..)

import Evergreen.V6.Gen.Params.Admin
import Evergreen.V6.Gen.Params.Channel.Id_
import Evergreen.V6.Gen.Params.End
import Evergreen.V6.Gen.Params.Example
import Evergreen.V6.Gen.Params.Ga.Email_
import Evergreen.V6.Gen.Params.Home_
import Evergreen.V6.Gen.Params.Log
import Evergreen.V6.Gen.Params.Login
import Evergreen.V6.Gen.Params.NotFound
import Evergreen.V6.Gen.Params.Register
import Evergreen.V6.Pages.Admin
import Evergreen.V6.Pages.Channel.Id_
import Evergreen.V6.Pages.End
import Evergreen.V6.Pages.Example
import Evergreen.V6.Pages.Ga.Email_
import Evergreen.V6.Pages.Home_
import Evergreen.V6.Pages.Log
import Evergreen.V6.Pages.Login
import Evergreen.V6.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V6.Gen.Params.Admin.Params Evergreen.V6.Pages.Admin.Model
    | End Evergreen.V6.Gen.Params.End.Params Evergreen.V6.Pages.End.Model
    | Example Evergreen.V6.Gen.Params.Example.Params Evergreen.V6.Pages.Example.Model
    | Home_ Evergreen.V6.Gen.Params.Home_.Params Evergreen.V6.Pages.Home_.Model
    | Log Evergreen.V6.Gen.Params.Log.Params Evergreen.V6.Pages.Log.Model
    | Login Evergreen.V6.Gen.Params.Login.Params Evergreen.V6.Pages.Login.Model
    | NotFound Evergreen.V6.Gen.Params.NotFound.Params
    | Register Evergreen.V6.Gen.Params.Register.Params Evergreen.V6.Pages.Register.Model
    | Channel__Id_ Evergreen.V6.Gen.Params.Channel.Id_.Params Evergreen.V6.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V6.Gen.Params.Ga.Email_.Params Evergreen.V6.Pages.Ga.Email_.Model
