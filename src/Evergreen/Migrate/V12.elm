module Evergreen.Migrate.V12 exposing (..)

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
import Evergreen.V11.Api.Data
import Evergreen.V11.Api.Logging
import Evergreen.V11.Api.User
import Evergreen.V11.Api.YoutubeModel
import Evergreen.V11.Bridge
import Evergreen.V11.Gen.Model
import Evergreen.V11.Gen.Msg
import Evergreen.V11.Gen.Pages
import Evergreen.V11.Gen.Params.Channel.Id_
import Evergreen.V11.Gen.Params.Ga.Email_
import Evergreen.V11.Gen.Params.Playlist.Id_
import Evergreen.V11.Pages.Admin
import Evergreen.V11.Pages.Channel.Id_
import Evergreen.V11.Pages.End
import Evergreen.V11.Pages.Example
import Evergreen.V11.Pages.Ga.Email_
import Evergreen.V11.Pages.Home_
import Evergreen.V11.Pages.Log
import Evergreen.V11.Pages.Login
import Evergreen.V11.Pages.Playlist.Id_
import Evergreen.V11.Pages.Register
import Evergreen.V11.Shared
import Evergreen.V11.Types
import Evergreen.V12.Api.Data
import Evergreen.V12.Api.Logging
import Evergreen.V12.Api.User
import Evergreen.V12.Api.YoutubeModel
import Evergreen.V12.Bridge
import Evergreen.V12.Gen.Model
import Evergreen.V12.Gen.Msg
import Evergreen.V12.Gen.Pages
import Evergreen.V12.Gen.Params.Channel.Id_
import Evergreen.V12.Gen.Params.Ga.Email_
import Evergreen.V12.Gen.Params.Playlist.Id_
import Evergreen.V12.Pages.Admin
import Evergreen.V12.Pages.Channel.Id_
import Evergreen.V12.Pages.End
import Evergreen.V12.Pages.Example
import Evergreen.V12.Pages.Ga.Email_
import Evergreen.V12.Pages.Home_
import Evergreen.V12.Pages.Log
import Evergreen.V12.Pages.Login
import Evergreen.V12.Pages.Playlist.Id_
import Evergreen.V12.Pages.Register
import Evergreen.V12.Shared
import Evergreen.V12.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe


frontendModel : Evergreen.V11.Types.FrontendModel -> ModelMigration Evergreen.V12.Types.FrontendModel Evergreen.V12.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V11.Types.BackendModel -> ModelMigration Evergreen.V12.Types.BackendModel Evergreen.V12.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V11.Types.FrontendMsg -> MsgMigration Evergreen.V12.Types.FrontendMsg Evergreen.V12.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V11.Types.ToBackend -> MsgMigration Evergreen.V12.Types.ToBackend Evergreen.V12.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V11.Types.BackendMsg -> MsgMigration Evergreen.V12.Types.BackendMsg Evergreen.V12.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V11.Types.ToFrontend -> MsgMigration Evergreen.V12.Types.ToFrontend Evergreen.V12.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V11.Types.BackendModel -> Evergreen.V12.Types.BackendModel
migrate_Types_BackendModel old =
    { users = old.users |> Dict.map (\k -> migrate_Api_User_UserFull)
    , authenticatedSessions = old.authenticatedSessions
    , incrementedInt = old.incrementedInt
    , logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    , clientCredentials = old.clientCredentials
    , channels = old.channels
    , channelAssociations = old.channelAssociations
    , playlists = old.playlists |> Dict.map (\k -> migrate_Api_YoutubeModel_Playlist)
    , schedules = old.schedules
    , videos = old.videos
    , apiCallCount = old.apiCallCount
    }


migrate_Types_FrontendModel : Evergreen.V11.Types.FrontendModel -> Evergreen.V12.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_Types_ToBackend : Evergreen.V11.Types.ToBackend -> Evergreen.V12.Types.ToBackend
migrate_Types_ToBackend old =
    old |> migrate_Bridge_ToBackend


migrate_Api_Data_Data : (value_old -> value_new) -> Evergreen.V11.Api.Data.Data value_old -> Evergreen.V12.Api.Data.Data value_new
migrate_Api_Data_Data migrate_value old =
    case old of
        Evergreen.V11.Api.Data.NotAsked ->
            Evergreen.V12.Api.Data.NotAsked

        Evergreen.V11.Api.Data.Loading ->
            Evergreen.V12.Api.Data.Loading

        Evergreen.V11.Api.Data.Failure p0 ->
            Evergreen.V12.Api.Data.Failure p0

        Evergreen.V11.Api.Data.Success p0 ->
            Evergreen.V12.Api.Data.Success (p0 |> migrate_value)


migrate_Api_Logging_LogEntry : Evergreen.V11.Api.Logging.LogEntry -> Evergreen.V12.Api.Logging.LogEntry
migrate_Api_Logging_LogEntry old =
    { message = old.message
    , timestamp = old.timestamp
    , logLevel = old.logLevel |> migrate_Api_Logging_LogLevel
    }


migrate_Api_Logging_LogLevel : Evergreen.V11.Api.Logging.LogLevel -> Evergreen.V12.Api.Logging.LogLevel
migrate_Api_Logging_LogLevel old =
    case old of
        Evergreen.V11.Api.Logging.Error ->
            Evergreen.V12.Api.Logging.Error

        Evergreen.V11.Api.Logging.Info ->
            Evergreen.V12.Api.Logging.Info

        Evergreen.V11.Api.Logging.Alert ->
            Evergreen.V12.Api.Logging.Alert


migrate_Api_User_Role : Evergreen.V11.Api.User.Role -> Evergreen.V12.Api.User.Role
migrate_Api_User_Role old =
    case old of
        Evergreen.V11.Api.User.Basic ->
            Evergreen.V12.Api.User.Basic

        Evergreen.V11.Api.User.Editor ->
            Evergreen.V12.Api.User.Editor

        Evergreen.V11.Api.User.Admin ->
            Evergreen.V12.Api.User.Admin


migrate_Api_User_User : Evergreen.V11.Api.User.User -> Evergreen.V12.Api.User.User
migrate_Api_User_User old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    }


migrate_Api_User_UserFull : Evergreen.V11.Api.User.UserFull -> Evergreen.V12.Api.User.UserFull
migrate_Api_User_UserFull old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    , passwordHash = old.passwordHash
    , salt = old.salt
    }


migrate_Api_YoutubeModel_Channel : Evergreen.V11.Api.YoutubeModel.Channel -> Evergreen.V12.Api.YoutubeModel.Channel
migrate_Api_YoutubeModel_Channel old =
    old


migrate_Api_YoutubeModel_DaysOfWeek : Evergreen.V11.Api.YoutubeModel.DaysOfWeek -> Evergreen.V12.Api.YoutubeModel.DaysOfWeek
migrate_Api_YoutubeModel_DaysOfWeek old =
    old


migrate_Api_YoutubeModel_Playlist : Evergreen.V11.Api.YoutubeModel.Playlist -> Evergreen.V12.Api.YoutubeModel.Playlist
migrate_Api_YoutubeModel_Playlist old =
    { id = old.id
    , title = old.title
    , description = old.description
    , channelId = old.channelId
    , monitor = False
    }


migrate_Api_YoutubeModel_Schedule : Evergreen.V11.Api.YoutubeModel.Schedule -> Evergreen.V12.Api.YoutubeModel.Schedule
migrate_Api_YoutubeModel_Schedule old =
    { playlistId = old.playlistId
    , hour = old.hour
    , minute = old.minute
    , days = old.days |> migrate_Api_YoutubeModel_DaysOfWeek
    }


migrate_Bridge_ToBackend : Evergreen.V11.Bridge.ToBackend -> Evergreen.V12.Bridge.ToBackend
migrate_Bridge_ToBackend old =
    case old of
        Evergreen.V11.Bridge.AttemptRegistration p0 ->
            Evergreen.V12.Bridge.AttemptRegistration p0

        Evergreen.V11.Bridge.AttemptSignIn p0 ->
            Evergreen.V12.Bridge.AttemptSignIn p0

        Evergreen.V11.Bridge.AttemptSignOut ->
            Evergreen.V12.Bridge.AttemptSignOut

        Evergreen.V11.Bridge.AttemptGetCredentials ->
            Evergreen.V12.Bridge.AttemptGetCredentials

        Evergreen.V11.Bridge.AttemptGetChannels p0 ->
            Evergreen.V12.Bridge.AttemptGetChannels p0

        Evergreen.V11.Bridge.FetchChannelsFromYoutube p0 ->
            Evergreen.V12.Bridge.FetchChannelsFromYoutube p0

        Evergreen.V11.Bridge.FetchPlaylistsFromYoutube p0 ->
            Evergreen.V12.Bridge.FetchPlaylistsFromYoutube p0

        Evergreen.V11.Bridge.FetchVideosFromYoutube p0 ->
            Evergreen.V12.Bridge.FetchVideosFromYoutube p0

        Evergreen.V11.Bridge.AttemptGetChannelAndPlaylists p0 ->
            Evergreen.V12.Bridge.AttemptGetChannelAndPlaylists p0

        Evergreen.V11.Bridge.AttemptGetVideos p0 ->
            Evergreen.V12.Bridge.AttemptGetVideos p0

        Evergreen.V11.Bridge.AttemptGetLogs ->
            Evergreen.V12.Bridge.AttemptGetLogs

        Evergreen.V11.Bridge.UpdateSchedule p0 ->
            Evergreen.V12.Bridge.UpdateSchedule (p0 |> migrate_Api_YoutubeModel_Schedule)

        Evergreen.V11.Bridge.NoOpToBackend ->
            Evergreen.V12.Bridge.NoOpToBackend


migrate_Gen_Model_Model : Evergreen.V11.Gen.Model.Model -> Evergreen.V12.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V11.Gen.Model.Redirecting_ ->
            Evergreen.V12.Gen.Model.Redirecting_

        Evergreen.V11.Gen.Model.Admin p0 p1 ->
            Evergreen.V12.Gen.Model.Admin p0 (p1 |> migrate_Pages_Admin_Model)

        Evergreen.V11.Gen.Model.End p0 p1 ->
            Evergreen.V12.Gen.Model.End p0 (p1 |> migrate_Pages_End_Model)

        Evergreen.V11.Gen.Model.Example p0 p1 ->
            Evergreen.V12.Gen.Model.Example p0 (p1 |> migrate_Pages_Example_Model)

        Evergreen.V11.Gen.Model.Home_ p0 p1 ->
            Evergreen.V12.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V11.Gen.Model.Log p0 p1 ->
            Evergreen.V12.Gen.Model.Log p0 (p1 |> migrate_Pages_Log_Model)

        Evergreen.V11.Gen.Model.Login p0 p1 ->
            Evergreen.V12.Gen.Model.Login p0 (p1 |> migrate_Pages_Login_Model)

        Evergreen.V11.Gen.Model.NotFound p0 ->
            Evergreen.V12.Gen.Model.NotFound p0

        Evergreen.V11.Gen.Model.Register p0 p1 ->
            Evergreen.V12.Gen.Model.Register p0 (p1 |> migrate_Pages_Register_Model)

        Evergreen.V11.Gen.Model.Channel__Id_ p0 p1 ->
            Evergreen.V12.Gen.Model.Channel__Id_ (p0 |> migrate_Gen_Params_Channel_Id__Params)
                (p1 |> migrate_Pages_Channel_Id__Model)

        Evergreen.V11.Gen.Model.Ga__Email_ p0 p1 ->
            Evergreen.V12.Gen.Model.Ga__Email_ (p0 |> migrate_Gen_Params_Ga_Email__Params)
                (p1 |> migrate_Pages_Ga_Email__Model)

        Evergreen.V11.Gen.Model.Playlist__Id_ p0 p1 ->
            Evergreen.V12.Gen.Model.Playlist__Id_ (p0 |> migrate_Gen_Params_Playlist_Id__Params)
                (p1 |> migrate_Pages_Playlist_Id__Model)


migrate_Gen_Msg_Msg : Evergreen.V11.Gen.Msg.Msg -> Evergreen.V12.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V11.Gen.Msg.Admin p0 ->
            Evergreen.V12.Gen.Msg.Admin (p0 |> migrate_Pages_Admin_Msg)

        Evergreen.V11.Gen.Msg.End p0 ->
            Evergreen.V12.Gen.Msg.End (p0 |> migrate_Pages_End_Msg)

        Evergreen.V11.Gen.Msg.Example p0 ->
            Evergreen.V12.Gen.Msg.Example (p0 |> migrate_Pages_Example_Msg)

        Evergreen.V11.Gen.Msg.Home_ p0 ->
            Evergreen.V12.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V11.Gen.Msg.Log p0 ->
            Evergreen.V12.Gen.Msg.Log (p0 |> migrate_Pages_Log_Msg)

        Evergreen.V11.Gen.Msg.Login p0 ->
            Evergreen.V12.Gen.Msg.Login (p0 |> migrate_Pages_Login_Msg)

        Evergreen.V11.Gen.Msg.Register p0 ->
            Evergreen.V12.Gen.Msg.Register (p0 |> migrate_Pages_Register_Msg)

        Evergreen.V11.Gen.Msg.Channel__Id_ p0 ->
            Evergreen.V12.Gen.Msg.Channel__Id_ (p0 |> migrate_Pages_Channel_Id__Msg)

        Evergreen.V11.Gen.Msg.Ga__Email_ p0 ->
            Evergreen.V12.Gen.Msg.Ga__Email_ (p0 |> migrate_Pages_Ga_Email__Msg)

        Evergreen.V11.Gen.Msg.Playlist__Id_ p0 ->
            Evergreen.V12.Gen.Msg.Playlist__Id_ (p0 |> migrate_Pages_Playlist_Id__Msg)


migrate_Gen_Pages_Model : Evergreen.V11.Gen.Pages.Model -> Evergreen.V12.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V11.Gen.Pages.Msg -> Evergreen.V12.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Gen_Params_Channel_Id__Params : Evergreen.V11.Gen.Params.Channel.Id_.Params -> Evergreen.V12.Gen.Params.Channel.Id_.Params
migrate_Gen_Params_Channel_Id__Params old =
    old


migrate_Gen_Params_Ga_Email__Params : Evergreen.V11.Gen.Params.Ga.Email_.Params -> Evergreen.V12.Gen.Params.Ga.Email_.Params
migrate_Gen_Params_Ga_Email__Params old =
    old


migrate_Gen_Params_Playlist_Id__Params : Evergreen.V11.Gen.Params.Playlist.Id_.Params -> Evergreen.V12.Gen.Params.Playlist.Id_.Params
migrate_Gen_Params_Playlist_Id__Params old =
    old


migrate_Pages_Admin_Model : Evergreen.V11.Pages.Admin.Model -> Evergreen.V12.Pages.Admin.Model
migrate_Pages_Admin_Model old =
    old


migrate_Pages_Admin_Msg : Evergreen.V11.Pages.Admin.Msg -> Evergreen.V12.Pages.Admin.Msg
migrate_Pages_Admin_Msg old =
    case old of
        Evergreen.V11.Pages.Admin.ReplaceMe ->
            Evergreen.V12.Pages.Admin.ReplaceMe


migrate_Pages_Channel_Id__Model : Evergreen.V11.Pages.Channel.Id_.Model -> Evergreen.V12.Pages.Channel.Id_.Model
migrate_Pages_Channel_Id__Model old =
    { channelId = old.channelId
    , channel = old.channel
    , playlists = old.playlists |> Dict.map (\k -> migrate_Api_YoutubeModel_Playlist)
    , schedules = old.schedules
    }


migrate_Pages_Channel_Id__Msg : Evergreen.V11.Pages.Channel.Id_.Msg -> Evergreen.V12.Pages.Channel.Id_.Msg
migrate_Pages_Channel_Id__Msg old =
    case old of
        Evergreen.V11.Pages.Channel.Id_.GotChannelAndPlaylists p0 p1 p2 ->
            Evergreen.V12.Pages.Channel.Id_.GotChannelAndPlaylists (p0 |> migrate_Api_YoutubeModel_Channel)
                (p1 |> Dict.map (\k -> migrate_Api_YoutubeModel_Playlist))
                p2

        Evergreen.V11.Pages.Channel.Id_.GetPlaylists ->
            Evergreen.V12.Pages.Channel.Id_.GetPlaylists

        Evergreen.V11.Pages.Channel.Id_.Schedule_UpdateSchedule p0 ->
            Evergreen.V12.Pages.Channel.Id_.Schedule_UpdateSchedule (p0 |> migrate_Api_YoutubeModel_Schedule)


migrate_Pages_End_Model : Evergreen.V11.Pages.End.Model -> Evergreen.V12.Pages.End.Model
migrate_Pages_End_Model old =
    old


migrate_Pages_End_Msg : Evergreen.V11.Pages.End.Msg -> Evergreen.V12.Pages.End.Msg
migrate_Pages_End_Msg old =
    case old of
        Evergreen.V11.Pages.End.ReplaceMe ->
            Evergreen.V12.Pages.End.ReplaceMe


migrate_Pages_Example_Model : Evergreen.V11.Pages.Example.Model -> Evergreen.V12.Pages.Example.Model
migrate_Pages_Example_Model old =
    { clientCredentials = old.clientCredentials |> List.map (\k -> (k.email, k)) |> Dict.fromList
    , currentTime = old.currentTime
    , noAccessKeysIncluded = False
    }


migrate_Pages_Example_Msg : Evergreen.V11.Pages.Example.Msg -> Evergreen.V12.Pages.Example.Msg
migrate_Pages_Example_Msg old =
    case old of
        Evergreen.V11.Pages.Example.GotCredentials p0 ->
            Evergreen.V12.Pages.Example.GotCredentials Dict.empty

        Evergreen.V11.Pages.Example.GetChannels p0 ->
            Evergreen.V12.Pages.Example.GetChannels p0

        Evergreen.V11.Pages.Example.Tick p0 ->
            Evergreen.V12.Pages.Example.Tick p0


migrate_Pages_Ga_Email__Model : Evergreen.V11.Pages.Ga.Email_.Model -> Evergreen.V12.Pages.Ga.Email_.Model
migrate_Pages_Ga_Email__Model old =
    old


migrate_Pages_Ga_Email__Msg : Evergreen.V11.Pages.Ga.Email_.Msg -> Evergreen.V12.Pages.Ga.Email_.Msg
migrate_Pages_Ga_Email__Msg old =
    case old of
        Evergreen.V11.Pages.Ga.Email_.GotChannels p0 ->
            Evergreen.V12.Pages.Ga.Email_.GotChannels p0

        Evergreen.V11.Pages.Ga.Email_.GetChannels ->
            Evergreen.V12.Pages.Ga.Email_.GetChannels


migrate_Pages_Home__Model : Evergreen.V11.Pages.Home_.Model -> Evergreen.V12.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V11.Pages.Home_.Msg -> Evergreen.V12.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V11.Pages.Home_.Noop ->
            Evergreen.V12.Pages.Home_.Noop


migrate_Pages_Log_Model : Evergreen.V11.Pages.Log.Model -> Evergreen.V12.Pages.Log.Model
migrate_Pages_Log_Model old =
    { logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    }


migrate_Pages_Log_Msg : Evergreen.V11.Pages.Log.Msg -> Evergreen.V12.Pages.Log.Msg
migrate_Pages_Log_Msg old =
    case old of
        Evergreen.V11.Pages.Log.GotLogs p0 ->
            Evergreen.V12.Pages.Log.GotLogs (p0 |> List.map migrate_Api_Logging_LogEntry)


migrate_Pages_Login_Field : Evergreen.V11.Pages.Login.Field -> Evergreen.V12.Pages.Login.Field
migrate_Pages_Login_Field old =
    case old of
        Evergreen.V11.Pages.Login.Email ->
            Evergreen.V12.Pages.Login.Email

        Evergreen.V11.Pages.Login.Password ->
            Evergreen.V12.Pages.Login.Password


migrate_Pages_Login_Model : Evergreen.V11.Pages.Login.Model -> Evergreen.V12.Pages.Login.Model
migrate_Pages_Login_Model old =
    old


migrate_Pages_Login_Msg : Evergreen.V11.Pages.Login.Msg -> Evergreen.V12.Pages.Login.Msg
migrate_Pages_Login_Msg old =
    case old of
        Evergreen.V11.Pages.Login.Updated p0 p1 ->
            Evergreen.V12.Pages.Login.Updated (p0 |> migrate_Pages_Login_Field) p1

        Evergreen.V11.Pages.Login.ToggledShowPassword ->
            Evergreen.V12.Pages.Login.ToggledShowPassword

        Evergreen.V11.Pages.Login.ClickedSubmit ->
            Evergreen.V12.Pages.Login.ClickedSubmit

        Evergreen.V11.Pages.Login.GotUser p0 ->
            Evergreen.V12.Pages.Login.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Playlist_Id__Model : Evergreen.V11.Pages.Playlist.Id_.Model -> Evergreen.V12.Pages.Playlist.Id_.Model
migrate_Pages_Playlist_Id__Model old =
    old


migrate_Pages_Playlist_Id__Msg : Evergreen.V11.Pages.Playlist.Id_.Msg -> Evergreen.V12.Pages.Playlist.Id_.Msg
migrate_Pages_Playlist_Id__Msg old =
    case old of
        Evergreen.V11.Pages.Playlist.Id_.GotVideos p0 p1 ->
            Evergreen.V12.Pages.Playlist.Id_.GotVideos (p0 |> migrate_Api_YoutubeModel_Playlist) p1

        Evergreen.V11.Pages.Playlist.Id_.GetVideos ->
            Evergreen.V12.Pages.Playlist.Id_.GetVideos


migrate_Pages_Register_Field : Evergreen.V11.Pages.Register.Field -> Evergreen.V12.Pages.Register.Field
migrate_Pages_Register_Field old =
    case old of
        Evergreen.V11.Pages.Register.Email ->
            Evergreen.V12.Pages.Register.Email

        Evergreen.V11.Pages.Register.Password ->
            Evergreen.V12.Pages.Register.Password


migrate_Pages_Register_Model : Evergreen.V11.Pages.Register.Model -> Evergreen.V12.Pages.Register.Model
migrate_Pages_Register_Model old =
    old


migrate_Pages_Register_Msg : Evergreen.V11.Pages.Register.Msg -> Evergreen.V12.Pages.Register.Msg
migrate_Pages_Register_Msg old =
    case old of
        Evergreen.V11.Pages.Register.Updated p0 p1 ->
            Evergreen.V12.Pages.Register.Updated (p0 |> migrate_Pages_Register_Field) p1

        Evergreen.V11.Pages.Register.ToggledShowPassword ->
            Evergreen.V12.Pages.Register.ToggledShowPassword

        Evergreen.V11.Pages.Register.ClickedSubmit ->
            Evergreen.V12.Pages.Register.ClickedSubmit

        Evergreen.V11.Pages.Register.GotUser p0 ->
            Evergreen.V12.Pages.Register.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Shared_Model : Evergreen.V11.Shared.Model -> Evergreen.V12.Shared.Model
migrate_Shared_Model old =
    { viewWidth = old.viewWidth
    , user = old.user |> Maybe.map migrate_Api_User_User
    , toastMessage = old.toastMessage
    }


migrate_Shared_Msg : Evergreen.V11.Shared.Msg -> Evergreen.V12.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V11.Shared.GotViewWidth p0 ->
            Evergreen.V12.Shared.GotViewWidth p0

        Evergreen.V11.Shared.Noop ->
            Evergreen.V12.Shared.Noop

        Evergreen.V11.Shared.SignInUser p0 ->
            Evergreen.V12.Shared.SignInUser (p0 |> migrate_Api_User_User)

        Evergreen.V11.Shared.SignOutUser ->
            Evergreen.V12.Shared.SignOutUser

        Evergreen.V11.Shared.ShowToastMessage p0 ->
            Evergreen.V12.Shared.ShowToastMessage p0

        Evergreen.V11.Shared.HideToastMessage p0 ->
            Evergreen.V12.Shared.HideToastMessage p0


migrate_Types_FrontendMsg : Evergreen.V11.Types.FrontendMsg -> Evergreen.V12.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V11.Types.ChangedUrl p0 ->
            Evergreen.V12.Types.ChangedUrl p0

        Evergreen.V11.Types.ClickedLink p0 ->
            Evergreen.V12.Types.ClickedLink p0

        Evergreen.V11.Types.Shared p0 ->
            Evergreen.V12.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V11.Types.Page p0 ->
            Evergreen.V12.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V11.Types.Noop ->
            Evergreen.V12.Types.Noop


migrate_Types_ToFrontend : Evergreen.V11.Types.ToFrontend -> Evergreen.V12.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V11.Types.PageMsg p0 ->
            Evergreen.V12.Types.PageMsg (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V11.Types.SharedMsg p0 ->
            Evergreen.V12.Types.SharedMsg (p0 |> migrate_Shared_Msg)

        Evergreen.V11.Types.NoOpToFrontend ->
            Evergreen.V12.Types.NoOpToFrontend
