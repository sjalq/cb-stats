module Evergreen.V5.Gen.Model exposing (..)

import Evergreen.V5.Gen.Params.Admin
import Evergreen.V5.Gen.Params.Channel.Id_
import Evergreen.V5.Gen.Params.End
import Evergreen.V5.Gen.Params.Example
import Evergreen.V5.Gen.Params.Ga.Email_
import Evergreen.V5.Gen.Params.Home_
import Evergreen.V5.Gen.Params.Login
import Evergreen.V5.Gen.Params.NotFound
import Evergreen.V5.Gen.Params.Register
import Evergreen.V5.Pages.Admin
import Evergreen.V5.Pages.Channel.Id_
import Evergreen.V5.Pages.End
import Evergreen.V5.Pages.Example
import Evergreen.V5.Pages.Ga.Email_
import Evergreen.V5.Pages.Home_
import Evergreen.V5.Pages.Login
import Evergreen.V5.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V5.Gen.Params.Admin.Params Evergreen.V5.Pages.Admin.Model
    | End Evergreen.V5.Gen.Params.End.Params Evergreen.V5.Pages.End.Model
    | Example Evergreen.V5.Gen.Params.Example.Params Evergreen.V5.Pages.Example.Model
    | Home_ Evergreen.V5.Gen.Params.Home_.Params Evergreen.V5.Pages.Home_.Model
    | Login Evergreen.V5.Gen.Params.Login.Params Evergreen.V5.Pages.Login.Model
    | NotFound Evergreen.V5.Gen.Params.NotFound.Params
    | Register Evergreen.V5.Gen.Params.Register.Params Evergreen.V5.Pages.Register.Model
    | Channel__Id_ Evergreen.V5.Gen.Params.Channel.Id_.Params Evergreen.V5.Pages.Channel.Id_.Model
    | Ga__Email_ Evergreen.V5.Gen.Params.Ga.Email_.Params Evergreen.V5.Pages.Ga.Email_.Model
