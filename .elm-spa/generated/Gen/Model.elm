module Gen.Model exposing (Model(..))

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
import Gen.Params.Playlist.Id_
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
import Pages.Playlist.Id_


type Model
    = Redirecting_
    | Admin Gen.Params.Admin.Params Pages.Admin.Model
    | End Gen.Params.End.Params Pages.End.Model
    | Example Gen.Params.Example.Params Pages.Example.Model
    | Home_ Gen.Params.Home_.Params Pages.Home_.Model
    | Log Gen.Params.Log.Params Pages.Log.Model
    | Login Gen.Params.Login.Params Pages.Login.Model
    | NotFound Gen.Params.NotFound.Params
    | Register Gen.Params.Register.Params Pages.Register.Model
    | Channel__Id_ Gen.Params.Channel.Id_.Params Pages.Channel.Id_.Model
    | Ga__Email_ Gen.Params.Ga.Email_.Params Pages.Ga.Email_.Model
    | Playlist__Id_ Gen.Params.Playlist.Id_.Params Pages.Playlist.Id_.Model

