module Gen.Msg exposing (Msg(..))

import Gen.Params.Admin
import Gen.Params.End
import Gen.Params.Example
import Gen.Params.Home_
import Gen.Params.Log
import Gen.Params.Login
import Gen.Params.NotFound
import Gen.Params.Register
import Gen.Params.Channel.Id_
import Gen.Params.Ga.Email_
import Pages.Admin
import Pages.End
import Pages.Example
import Pages.Home_
import Pages.Log
import Pages.Login
import Pages.NotFound
import Pages.Register
import Pages.Channel.Id_
import Pages.Ga.Email_


type Msg
    = Admin Pages.Admin.Msg
    | End Pages.End.Msg
    | Example Pages.Example.Msg
    | Home_ Pages.Home_.Msg
    | Log Pages.Log.Msg
    | Login Pages.Login.Msg
    | Register Pages.Register.Msg
    | Channel__Id_ Pages.Channel.Id_.Msg
    | Ga__Email_ Pages.Ga.Email_.Msg

