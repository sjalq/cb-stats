module Evergreen.V4.Gen.Model exposing (..)

import Evergreen.V4.Gen.Params.Admin
import Evergreen.V4.Gen.Params.End
import Evergreen.V4.Gen.Params.Example
import Evergreen.V4.Gen.Params.Home_
import Evergreen.V4.Gen.Params.Login
import Evergreen.V4.Gen.Params.NotFound
import Evergreen.V4.Gen.Params.Register
import Evergreen.V4.Pages.Admin
import Evergreen.V4.Pages.End
import Evergreen.V4.Pages.Example
import Evergreen.V4.Pages.Home_
import Evergreen.V4.Pages.Login
import Evergreen.V4.Pages.Register


type Model
    = Redirecting_
    | Admin Evergreen.V4.Gen.Params.Admin.Params Evergreen.V4.Pages.Admin.Model
    | End Evergreen.V4.Gen.Params.End.Params Evergreen.V4.Pages.End.Model
    | Example Evergreen.V4.Gen.Params.Example.Params Evergreen.V4.Pages.Example.Model
    | Home_ Evergreen.V4.Gen.Params.Home_.Params Evergreen.V4.Pages.Home_.Model
    | Login Evergreen.V4.Gen.Params.Login.Params Evergreen.V4.Pages.Login.Model
    | NotFound Evergreen.V4.Gen.Params.NotFound.Params
    | Register Evergreen.V4.Gen.Params.Register.Params Evergreen.V4.Pages.Register.Model
