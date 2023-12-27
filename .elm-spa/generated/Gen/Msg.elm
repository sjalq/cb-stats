module Gen.Msg exposing (Msg(..))

import Gen.Params.Admin
import Gen.Params.End
import Gen.Params.Example
import Gen.Params.Home_
import Gen.Params.Login
import Gen.Params.NotFound
import Gen.Params.Register
import Pages.Admin
import Pages.End
import Pages.Example
import Pages.Home_
import Pages.Login
import Pages.NotFound
import Pages.Register


type Msg
    = Admin Pages.Admin.Msg
    | End Pages.End.Msg
    | Example Pages.Example.Msg
    | Home_ Pages.Home_.Msg
    | Login Pages.Login.Msg
    | Register Pages.Register.Msg

