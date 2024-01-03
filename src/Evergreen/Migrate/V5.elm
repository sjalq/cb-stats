module Evergreen.Migrate.V5 exposing (..)

{-| This migration file was automatically generated by the lamdera compiler.

It includes:

  - A migration for each of the 6 Lamdera core types that has changed
  - A function named `migrate_ModuleName_TypeName` for each changed/custom type

Expect to see:

  - `Unimplementеd` values as placeholders wherever I was unable to figure out a clear migration path for you
  - `@NOTICE` comments for things you should know about, i.e. new custom type constructors that won't get any
    value mappings from the old type by default

You can edit this file however you wish! It won't be generated again.

See <https://dashboard.lamdera.app/docs/evergreen> for more info.

-}

import Dict
import Evergreen.V4.Api.Data
import Evergreen.V4.Api.Logging
import Evergreen.V4.Api.User
import Evergreen.V4.Bridge
import Evergreen.V4.Gen.Model
import Evergreen.V4.Gen.Msg
import Evergreen.V4.Gen.Pages
import Evergreen.V4.Json.Auto.AccessToken
import Evergreen.V4.Pages.Admin
import Evergreen.V4.Pages.End
import Evergreen.V4.Pages.Example
import Evergreen.V4.Pages.Home_
import Evergreen.V4.Pages.Login
import Evergreen.V4.Pages.Register
import Evergreen.V4.Shared
import Evergreen.V4.Types
import Evergreen.V5.Api.Data
import Evergreen.V5.Api.Logging
import Evergreen.V5.Api.User
import Evergreen.V5.Bridge
import Evergreen.V5.Gen.Model
import Evergreen.V5.Gen.Msg
import Evergreen.V5.Gen.Pages
import Evergreen.V5.Json.Auto.AccessToken
import Evergreen.V5.Pages.Admin
import Evergreen.V5.Pages.End
import Evergreen.V5.Pages.Example
import Evergreen.V5.Pages.Home_
import Evergreen.V5.Pages.Login
import Evergreen.V5.Pages.Register
import Evergreen.V5.Shared
import Evergreen.V5.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe


frontendModel : Evergreen.V4.Types.FrontendModel -> ModelMigration Evergreen.V5.Types.FrontendModel Evergreen.V5.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V4.Types.BackendModel -> ModelMigration Evergreen.V5.Types.BackendModel Evergreen.V5.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V4.Types.FrontendMsg -> MsgMigration Evergreen.V5.Types.FrontendMsg Evergreen.V5.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V4.Types.ToBackend -> MsgMigration Evergreen.V5.Types.ToBackend Evergreen.V5.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V4.Types.BackendMsg -> MsgMigration Evergreen.V5.Types.BackendMsg Evergreen.V5.Types.BackendMsg
backendMsg old =
    MsgMigrated ( migrate_Types_BackendMsg old, Cmd.none )


toFrontend : Evergreen.V4.Types.ToFrontend -> MsgMigration Evergreen.V5.Types.ToFrontend Evergreen.V5.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V4.Types.BackendModel -> Evergreen.V5.Types.BackendModel
migrate_Types_BackendModel old =
    { users = old.users |> Dict.map (\k -> migrate_Api_User_UserFull)
    , authenticatedSessions = old.authenticatedSessions
    , incrementedInt = old.incrementedInt
    , logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    , clientCredentials = old.clientCredentials
    , channels = Dict.empty
    , channelAssociations = []
    , playlists = Dict.empty
    }


migrate_Types_FrontendModel : Evergreen.V4.Types.FrontendModel -> Evergreen.V5.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_Types_ToBackend : Evergreen.V4.Types.ToBackend -> Evergreen.V5.Types.ToBackend
migrate_Types_ToBackend old =
    old |> migrate_Bridge_ToBackend


migrate_Api_Data_Data : (value_old -> value_new) -> Evergreen.V4.Api.Data.Data value_old -> Evergreen.V5.Api.Data.Data value_new
migrate_Api_Data_Data migrate_value old =
    case old of
        Evergreen.V4.Api.Data.NotAsked ->
            Evergreen.V5.Api.Data.NotAsked

        Evergreen.V4.Api.Data.Loading ->
            Evergreen.V5.Api.Data.Loading

        Evergreen.V4.Api.Data.Failure p0 ->
            Evergreen.V5.Api.Data.Failure p0

        Evergreen.V4.Api.Data.Success p0 ->
            Evergreen.V5.Api.Data.Success (p0 |> migrate_value)


migrate_Api_Logging_LogEntry : Evergreen.V4.Api.Logging.LogEntry -> Evergreen.V5.Api.Logging.LogEntry
migrate_Api_Logging_LogEntry old =
    { message = old.message
    , timeStamp = old.timeStamp
    , logLevel = old.logLevel |> migrate_Api_Logging_LogLevel
    }


migrate_Api_Logging_LogLevel : Evergreen.V4.Api.Logging.LogLevel -> Evergreen.V5.Api.Logging.LogLevel
migrate_Api_Logging_LogLevel old =
    case old of
        Evergreen.V4.Api.Logging.Error ->
            Evergreen.V5.Api.Logging.Error

        Evergreen.V4.Api.Logging.Info ->
            Evergreen.V5.Api.Logging.Info

        Evergreen.V4.Api.Logging.Alert ->
            Evergreen.V5.Api.Logging.Alert


migrate_Api_User_Role : Evergreen.V4.Api.User.Role -> Evergreen.V5.Api.User.Role
migrate_Api_User_Role old =
    case old of
        Evergreen.V4.Api.User.Basic ->
            Evergreen.V5.Api.User.Basic

        Evergreen.V4.Api.User.Editor ->
            Evergreen.V5.Api.User.Editor

        Evergreen.V4.Api.User.Admin ->
            Evergreen.V5.Api.User.Admin


migrate_Api_User_User : Evergreen.V4.Api.User.User -> Evergreen.V5.Api.User.User
migrate_Api_User_User old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    }


migrate_Api_User_UserFull : Evergreen.V4.Api.User.UserFull -> Evergreen.V5.Api.User.UserFull
migrate_Api_User_UserFull old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    , passwordHash = old.passwordHash
    , salt = old.salt
    }


migrate_Bridge_ToBackend : Evergreen.V4.Bridge.ToBackend -> Evergreen.V5.Bridge.ToBackend
migrate_Bridge_ToBackend old =
    case old of
        Evergreen.V4.Bridge.AttemptRegistration p0 ->
            Evergreen.V5.Bridge.AttemptRegistration p0

        Evergreen.V4.Bridge.AttemptSignIn p0 ->
            Evergreen.V5.Bridge.AttemptSignIn p0

        Evergreen.V4.Bridge.AttemptSignOut ->
            Evergreen.V5.Bridge.AttemptSignOut

        Evergreen.V4.Bridge.AttemptGetCredentials ->
            Evergreen.V5.Bridge.AttemptGetCredentials

        Evergreen.V4.Bridge.AttemptGetChannels p0 ->
            Evergreen.V5.Bridge.AttemptGetChannels p0

        Evergreen.V4.Bridge.AttemptGetChannelsWithTime p0 p1 ->
            Evergreen.V5.Bridge.NoOpToBackend

        Evergreen.V4.Bridge.NoOpToBackend ->
            Evergreen.V5.Bridge.NoOpToBackend


migrate_Gen_Model_Model : Evergreen.V4.Gen.Model.Model -> Evergreen.V5.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V4.Gen.Model.Redirecting_ ->
            Evergreen.V5.Gen.Model.Redirecting_

        Evergreen.V4.Gen.Model.Admin p0 p1 ->
            Evergreen.V5.Gen.Model.Admin p0 (p1 |> migrate_Pages_Admin_Model)

        Evergreen.V4.Gen.Model.End p0 p1 ->
            Evergreen.V5.Gen.Model.End p0 (p1 |> migrate_Pages_End_Model)

        Evergreen.V4.Gen.Model.Example p0 p1 ->
            Evergreen.V5.Gen.Model.Example p0 (p1 |> migrate_Pages_Example_Model)

        Evergreen.V4.Gen.Model.Home_ p0 p1 ->
            Evergreen.V5.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V4.Gen.Model.Login p0 p1 ->
            Evergreen.V5.Gen.Model.Login p0 (p1 |> migrate_Pages_Login_Model)

        Evergreen.V4.Gen.Model.NotFound p0 ->
            Evergreen.V5.Gen.Model.NotFound p0

        Evergreen.V4.Gen.Model.Register p0 p1 ->
            Evergreen.V5.Gen.Model.Register p0 (p1 |> migrate_Pages_Register_Model)


migrate_Gen_Msg_Msg : Evergreen.V4.Gen.Msg.Msg -> Evergreen.V5.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V4.Gen.Msg.Admin p0 ->
            Evergreen.V5.Gen.Msg.Admin (p0 |> migrate_Pages_Admin_Msg)

        Evergreen.V4.Gen.Msg.End p0 ->
            Evergreen.V5.Gen.Msg.End (p0 |> migrate_Pages_End_Msg)

        Evergreen.V4.Gen.Msg.Example p0 ->
            Evergreen.V5.Gen.Msg.Example (p0 |> migrate_Pages_Example_Msg)

        Evergreen.V4.Gen.Msg.Home_ p0 ->
            Evergreen.V5.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V4.Gen.Msg.Login p0 ->
            Evergreen.V5.Gen.Msg.Login (p0 |> migrate_Pages_Login_Msg)

        Evergreen.V4.Gen.Msg.Register p0 ->
            Evergreen.V5.Gen.Msg.Register (p0 |> migrate_Pages_Register_Msg)


migrate_Gen_Pages_Model : Evergreen.V4.Gen.Pages.Model -> Evergreen.V5.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V4.Gen.Pages.Msg -> Evergreen.V5.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Json_Auto_AccessToken_Root : Evergreen.V4.Json.Auto.AccessToken.Root -> Evergreen.V5.Json.Auto.AccessToken.Root
migrate_Json_Auto_AccessToken_Root old =
    old


migrate_Pages_Admin_Model : Evergreen.V4.Pages.Admin.Model -> Evergreen.V5.Pages.Admin.Model
migrate_Pages_Admin_Model old =
    old


migrate_Pages_Admin_Msg : Evergreen.V4.Pages.Admin.Msg -> Evergreen.V5.Pages.Admin.Msg
migrate_Pages_Admin_Msg old =
    case old of
        Evergreen.V4.Pages.Admin.ReplaceMe ->
            Evergreen.V5.Pages.Admin.ReplaceMe


migrate_Pages_End_Model : Evergreen.V4.Pages.End.Model -> Evergreen.V5.Pages.End.Model
migrate_Pages_End_Model old =
    old


migrate_Pages_End_Msg : Evergreen.V4.Pages.End.Msg -> Evergreen.V5.Pages.End.Msg
migrate_Pages_End_Msg old =
    case old of
        Evergreen.V4.Pages.End.ReplaceMe ->
            Evergreen.V5.Pages.End.ReplaceMe


migrate_Pages_Example_Model : Evergreen.V4.Pages.Example.Model -> Evergreen.V5.Pages.Example.Model
migrate_Pages_Example_Model old =
    old


migrate_Pages_Example_Msg : Evergreen.V4.Pages.Example.Msg -> Evergreen.V5.Pages.Example.Msg
migrate_Pages_Example_Msg old =
    case old of
        Evergreen.V4.Pages.Example.GotCredentials p0 ->
            Evergreen.V5.Pages.Example.GotCredentials p0

        Evergreen.V4.Pages.Example.GetChannels p0 ->
            Evergreen.V5.Pages.Example.GetChannels p0

        Evergreen.V4.Pages.Example.Tick p0 ->
            Evergreen.V5.Pages.Example.Tick p0


migrate_Pages_Home__Model : Evergreen.V4.Pages.Home_.Model -> Evergreen.V5.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V4.Pages.Home_.Msg -> Evergreen.V5.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V4.Pages.Home_.Noop ->
            Evergreen.V5.Pages.Home_.Noop


migrate_Pages_Login_Field : Evergreen.V4.Pages.Login.Field -> Evergreen.V5.Pages.Login.Field
migrate_Pages_Login_Field old =
    case old of
        Evergreen.V4.Pages.Login.Email ->
            Evergreen.V5.Pages.Login.Email

        Evergreen.V4.Pages.Login.Password ->
            Evergreen.V5.Pages.Login.Password


migrate_Pages_Login_Model : Evergreen.V4.Pages.Login.Model -> Evergreen.V5.Pages.Login.Model
migrate_Pages_Login_Model old =
    old


migrate_Pages_Login_Msg : Evergreen.V4.Pages.Login.Msg -> Evergreen.V5.Pages.Login.Msg
migrate_Pages_Login_Msg old =
    case old of
        Evergreen.V4.Pages.Login.Updated p0 p1 ->
            Evergreen.V5.Pages.Login.Updated (p0 |> migrate_Pages_Login_Field) p1

        Evergreen.V4.Pages.Login.ToggledShowPassword ->
            Evergreen.V5.Pages.Login.ToggledShowPassword

        Evergreen.V4.Pages.Login.ClickedSubmit ->
            Evergreen.V5.Pages.Login.ClickedSubmit

        Evergreen.V4.Pages.Login.GotUser p0 ->
            Evergreen.V5.Pages.Login.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Register_Field : Evergreen.V4.Pages.Register.Field -> Evergreen.V5.Pages.Register.Field
migrate_Pages_Register_Field old =
    case old of
        Evergreen.V4.Pages.Register.Email ->
            Evergreen.V5.Pages.Register.Email

        Evergreen.V4.Pages.Register.Password ->
            Evergreen.V5.Pages.Register.Password


migrate_Pages_Register_Model : Evergreen.V4.Pages.Register.Model -> Evergreen.V5.Pages.Register.Model
migrate_Pages_Register_Model old =
    old


migrate_Pages_Register_Msg : Evergreen.V4.Pages.Register.Msg -> Evergreen.V5.Pages.Register.Msg
migrate_Pages_Register_Msg old =
    case old of
        Evergreen.V4.Pages.Register.Updated p0 p1 ->
            Evergreen.V5.Pages.Register.Updated (p0 |> migrate_Pages_Register_Field) p1

        Evergreen.V4.Pages.Register.ToggledShowPassword ->
            Evergreen.V5.Pages.Register.ToggledShowPassword

        Evergreen.V4.Pages.Register.ClickedSubmit ->
            Evergreen.V5.Pages.Register.ClickedSubmit

        Evergreen.V4.Pages.Register.GotUser p0 ->
            Evergreen.V5.Pages.Register.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Shared_Model : Evergreen.V4.Shared.Model -> Evergreen.V5.Shared.Model
migrate_Shared_Model old =
    { viewWidth = old.viewWidth
    , user = old.user |> Maybe.map migrate_Api_User_User
    , toastMessage = old.toastMessage
    }


migrate_Shared_Msg : Evergreen.V4.Shared.Msg -> Evergreen.V5.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V4.Shared.GotViewWidth p0 ->
            Evergreen.V5.Shared.GotViewWidth p0

        Evergreen.V4.Shared.Noop ->
            Evergreen.V5.Shared.Noop

        Evergreen.V4.Shared.SignInUser p0 ->
            Evergreen.V5.Shared.SignInUser (p0 |> migrate_Api_User_User)

        Evergreen.V4.Shared.SignOutUser ->
            Evergreen.V5.Shared.SignOutUser

        Evergreen.V4.Shared.ShowToastMessage p0 ->
            Evergreen.V5.Shared.ShowToastMessage p0

        Evergreen.V4.Shared.HideToastMessage p0 ->
            Evergreen.V5.Shared.HideToastMessage p0


migrate_Types_BackendMsg : Evergreen.V4.Types.BackendMsg -> Evergreen.V5.Types.BackendMsg
migrate_Types_BackendMsg old =
    case old of
        Evergreen.V4.Types.OnConnect p0 p1 ->
            Evergreen.V5.Types.OnConnect p0 p1

        Evergreen.V4.Types.AuthenticateSession p0 p1 p2 p3 ->
            Evergreen.V5.Types.AuthenticateSession p0 p1 (p2 |> migrate_Api_User_User) p3

        Evergreen.V4.Types.VerifySession p0 p1 p2 ->
            Evergreen.V5.Types.VerifySession p0 p1 p2

        Evergreen.V4.Types.RegisterUser p0 p1 p2 p3 ->
            Evergreen.V5.Types.RegisterUser p0 p1 p2 p3

        Evergreen.V4.Types.Log_ p0 p1 p2 ->
            Evergreen.V5.Types.Log_ p0 (p1 |> migrate_Api_Logging_LogLevel) p2

        Evergreen.V4.Types.FetchChannels p0 ->
            Evergreen.V5.Types.FetchChannels p0

        Evergreen.V4.Types.FetchAccessToken p0 ->
            Evergreen.V5.Types.FetchAccessToken p0

        Evergreen.V4.Types.GotAccessTokenResponse p0 p1 ->
            Evergreen.V5.Types.GotAccessTokenResponse p0 (p1 |> migrate_Json_Auto_AccessToken_Root)

        Evergreen.V4.Types.GotFreshAccessTokenWithTime p0 p1 p2 ->
            Evergreen.V5.Types.GotFreshAccessTokenWithTime p0 p1 p2

        Evergreen.V4.Types.GetAccessTokens p0 ->
            Evergreen.V5.Types.NoOpBackendMsg

        Evergreen.V4.Types.GotAccessToken p0 p1 p2 ->
            Evergreen.V5.Types.GotAccessToken p0 p1 p2

        Evergreen.V4.Types.NoOpBackendMsg ->
            Evergreen.V5.Types.NoOpBackendMsg


migrate_Types_FrontendMsg : Evergreen.V4.Types.FrontendMsg -> Evergreen.V5.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V4.Types.ChangedUrl p0 ->
            Evergreen.V5.Types.ChangedUrl p0

        Evergreen.V4.Types.ClickedLink p0 ->
            Evergreen.V5.Types.ClickedLink p0

        Evergreen.V4.Types.Shared p0 ->
            Evergreen.V5.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V4.Types.Page p0 ->
            Evergreen.V5.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V4.Types.Noop ->
            Evergreen.V5.Types.Noop


migrate_Types_ToFrontend : Evergreen.V4.Types.ToFrontend -> Evergreen.V5.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V4.Types.PageMsg p0 ->
            Evergreen.V5.Types.PageMsg (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V4.Types.SharedMsg p0 ->
            Evergreen.V5.Types.SharedMsg (p0 |> migrate_Shared_Msg)

        Evergreen.V4.Types.NoOpToFrontend ->
            Evergreen.V5.Types.NoOpToFrontend