module Evergreen.Migrate.V37 exposing (..)

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
import Evergreen.V36.Api.Data
import Evergreen.V36.Api.Logging
import Evergreen.V36.Api.User
import Evergreen.V36.Api.YoutubeModel
import Evergreen.V36.Gen.Model
import Evergreen.V36.Gen.Msg
import Evergreen.V36.Gen.Pages
import Evergreen.V36.Gen.Params.Channel.Id_
import Evergreen.V36.Gen.Params.Ga.Email_
import Evergreen.V36.Gen.Params.Playlist.Id_
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
import Evergreen.V36.Shared
import Evergreen.V36.Types
import Evergreen.V37.Api.Data
import Evergreen.V37.Api.Logging
import Evergreen.V37.Api.User
import Evergreen.V37.Api.YoutubeModel
import Evergreen.V37.Gen.Model
import Evergreen.V37.Gen.Msg
import Evergreen.V37.Gen.Pages
import Evergreen.V37.Gen.Params.Channel.Id_
import Evergreen.V37.Gen.Params.Ga.Email_
import Evergreen.V37.Gen.Params.Playlist.Id_
import Evergreen.V37.Pages.Admin
import Evergreen.V37.Pages.Channel.Id_
import Evergreen.V37.Pages.End
import Evergreen.V37.Pages.Example
import Evergreen.V37.Pages.Ga.Email_
import Evergreen.V37.Pages.Home_
import Evergreen.V37.Pages.Log
import Evergreen.V37.Pages.Login
import Evergreen.V37.Pages.Playlist.Id_
import Evergreen.V37.Pages.Register
import Evergreen.V37.Shared
import Evergreen.V37.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe


frontendModel : Evergreen.V36.Types.FrontendModel -> ModelMigration Evergreen.V37.Types.FrontendModel Evergreen.V37.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V36.Types.BackendModel -> ModelMigration Evergreen.V37.Types.BackendModel Evergreen.V37.Types.BackendMsg
backendModel old =
    ModelUnchanged


frontendMsg : Evergreen.V36.Types.FrontendMsg -> MsgMigration Evergreen.V37.Types.FrontendMsg Evergreen.V37.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V36.Types.ToBackend -> MsgMigration Evergreen.V37.Types.ToBackend Evergreen.V37.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V36.Types.BackendMsg -> MsgMigration Evergreen.V37.Types.BackendMsg Evergreen.V37.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V36.Types.ToFrontend -> MsgMigration Evergreen.V37.Types.ToFrontend Evergreen.V37.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_FrontendModel : Evergreen.V36.Types.FrontendModel -> Evergreen.V37.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_Api_Data_Data : (value_old -> value_new) -> Evergreen.V36.Api.Data.Data value_old -> Evergreen.V37.Api.Data.Data value_new
migrate_Api_Data_Data migrate_value old =
    case old of
        Evergreen.V36.Api.Data.NotAsked ->
            Evergreen.V37.Api.Data.NotAsked

        Evergreen.V36.Api.Data.Loading ->
            Evergreen.V37.Api.Data.Loading

        Evergreen.V36.Api.Data.Failure p0 ->
            Evergreen.V37.Api.Data.Failure p0

        Evergreen.V36.Api.Data.Success p0 ->
            Evergreen.V37.Api.Data.Success (p0 |> migrate_value)


migrate_Api_Logging_LogEntry : Evergreen.V36.Api.Logging.LogEntry -> Evergreen.V37.Api.Logging.LogEntry
migrate_Api_Logging_LogEntry old =
    { message = old.message
    , timestamp = old.timestamp
    , logLevel = old.logLevel |> migrate_Api_Logging_LogLevel
    }


migrate_Api_Logging_LogLevel : Evergreen.V36.Api.Logging.LogLevel -> Evergreen.V37.Api.Logging.LogLevel
migrate_Api_Logging_LogLevel old =
    case old of
        Evergreen.V36.Api.Logging.Error ->
            Evergreen.V37.Api.Logging.Error

        Evergreen.V36.Api.Logging.Info ->
            Evergreen.V37.Api.Logging.Info

        Evergreen.V36.Api.Logging.Alert ->
            Evergreen.V37.Api.Logging.Alert


migrate_Api_User_Role : Evergreen.V36.Api.User.Role -> Evergreen.V37.Api.User.Role
migrate_Api_User_Role old =
    case old of
        Evergreen.V36.Api.User.Basic ->
            Evergreen.V37.Api.User.Basic

        Evergreen.V36.Api.User.Editor ->
            Evergreen.V37.Api.User.Editor

        Evergreen.V36.Api.User.Admin ->
            Evergreen.V37.Api.User.Admin


migrate_Api_User_User : Evergreen.V36.Api.User.User -> Evergreen.V37.Api.User.User
migrate_Api_User_User old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    }


migrate_Api_YoutubeModel_Channel : Evergreen.V36.Api.YoutubeModel.Channel -> Evergreen.V37.Api.YoutubeModel.Channel
migrate_Api_YoutubeModel_Channel old =
    old


migrate_Api_YoutubeModel_DaysOfWeek : Evergreen.V36.Api.YoutubeModel.DaysOfWeek -> Evergreen.V37.Api.YoutubeModel.DaysOfWeek
migrate_Api_YoutubeModel_DaysOfWeek old =
    old


migrate_Api_YoutubeModel_LiveStatus : Evergreen.V36.Api.YoutubeModel.LiveStatus -> Evergreen.V37.Api.YoutubeModel.LiveStatus
migrate_Api_YoutubeModel_LiveStatus old =
    case old of
        Evergreen.V36.Api.YoutubeModel.Unknown ->
            Evergreen.V37.Api.YoutubeModel.Unknown

        Evergreen.V36.Api.YoutubeModel.Uploaded ->
            Evergreen.V37.Api.YoutubeModel.Uploaded

        Evergreen.V36.Api.YoutubeModel.Scheduled p0 ->
            Evergreen.V37.Api.YoutubeModel.Scheduled p0

        Evergreen.V36.Api.YoutubeModel.Expired ->
            Evergreen.V37.Api.YoutubeModel.Expired

        Evergreen.V36.Api.YoutubeModel.Old ->
            Evergreen.V37.Api.YoutubeModel.Old

        Evergreen.V36.Api.YoutubeModel.Live ->
            Evergreen.V37.Api.YoutubeModel.Live

        Evergreen.V36.Api.YoutubeModel.Ended p0 ->
            Evergreen.V37.Api.YoutubeModel.Ended p0

        Evergreen.V36.Api.YoutubeModel.Impossibru ->
            Evergreen.V37.Api.YoutubeModel.Impossibru


migrate_Api_YoutubeModel_Playlist : Evergreen.V36.Api.YoutubeModel.Playlist -> Evergreen.V37.Api.YoutubeModel.Playlist
migrate_Api_YoutubeModel_Playlist old =
    old


migrate_Api_YoutubeModel_Schedule : Evergreen.V36.Api.YoutubeModel.Schedule -> Evergreen.V37.Api.YoutubeModel.Schedule
migrate_Api_YoutubeModel_Schedule old =
    { playlistId = old.playlistId
    , hour = old.hour
    , minute = old.minute
    , days = old.days |> migrate_Api_YoutubeModel_DaysOfWeek
    }


migrate_Api_YoutubeModel_Video : Evergreen.V36.Api.YoutubeModel.Video -> Evergreen.V37.Api.YoutubeModel.Video
migrate_Api_YoutubeModel_Video old =
    { id = old.id
    , title = old.title
    , description = old.description
    , videoOwnerChannelId = old.videoOwnerChannelId
    , videoOwnerChannelTitle = old.videoOwnerChannelTitle
    , playlistId = old.playlistId
    , thumbnailUrl = old.thumbnailUrl
    , publishedAt = old.publishedAt
    , liveChatId = old.liveChatId
    , liveStatus = old.liveStatus |> migrate_Api_YoutubeModel_LiveStatus
    , statsOnConclusion = old.statsOnConclusion
    , statsAfter24Hours = old.statsAfter24Hours
    , reportAfter24Hours = old.reportAfter24Hours
    , chatMsgCount = old.chatMsgCount
    }


migrate_Gen_Model_Model : Evergreen.V36.Gen.Model.Model -> Evergreen.V37.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V36.Gen.Model.Redirecting_ ->
            Evergreen.V37.Gen.Model.Redirecting_

        Evergreen.V36.Gen.Model.Admin p0 p1 ->
            Evergreen.V37.Gen.Model.Admin p0 (p1 |> migrate_Pages_Admin_Model)

        Evergreen.V36.Gen.Model.End p0 p1 ->
            Evergreen.V37.Gen.Model.End p0 (p1 |> migrate_Pages_End_Model)

        Evergreen.V36.Gen.Model.Example p0 p1 ->
            Evergreen.V37.Gen.Model.Example p0 (p1 |> migrate_Pages_Example_Model)

        Evergreen.V36.Gen.Model.Home_ p0 p1 ->
            Evergreen.V37.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V36.Gen.Model.Log p0 p1 ->
            Evergreen.V37.Gen.Model.Log p0 (p1 |> migrate_Pages_Log_Model)

        Evergreen.V36.Gen.Model.Login p0 p1 ->
            Evergreen.V37.Gen.Model.Login p0 (p1 |> migrate_Pages_Login_Model)

        Evergreen.V36.Gen.Model.NotFound p0 ->
            Evergreen.V37.Gen.Model.NotFound p0

        Evergreen.V36.Gen.Model.Register p0 p1 ->
            Evergreen.V37.Gen.Model.Register p0 (p1 |> migrate_Pages_Register_Model)

        Evergreen.V36.Gen.Model.Channel__Id_ p0 p1 ->
            Evergreen.V37.Gen.Model.Channel__Id_ (p0 |> migrate_Gen_Params_Channel_Id__Params)
                (p1 |> migrate_Pages_Channel_Id__Model)

        Evergreen.V36.Gen.Model.Ga__Email_ p0 p1 ->
            Evergreen.V37.Gen.Model.Ga__Email_ (p0 |> migrate_Gen_Params_Ga_Email__Params)
                (p1 |> migrate_Pages_Ga_Email__Model)

        Evergreen.V36.Gen.Model.Playlist__Id_ p0 p1 ->
            Evergreen.V37.Gen.Model.Playlist__Id_ (p0 |> migrate_Gen_Params_Playlist_Id__Params)
                (p1 |> migrate_Pages_Playlist_Id__Model)


migrate_Gen_Msg_Msg : Evergreen.V36.Gen.Msg.Msg -> Evergreen.V37.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V36.Gen.Msg.Admin p0 ->
            Evergreen.V37.Gen.Msg.Admin (p0 |> migrate_Pages_Admin_Msg)

        Evergreen.V36.Gen.Msg.End p0 ->
            Evergreen.V37.Gen.Msg.End (p0 |> migrate_Pages_End_Msg)

        Evergreen.V36.Gen.Msg.Example p0 ->
            Evergreen.V37.Gen.Msg.Example (p0 |> migrate_Pages_Example_Msg)

        Evergreen.V36.Gen.Msg.Home_ p0 ->
            Evergreen.V37.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V36.Gen.Msg.Log p0 ->
            Evergreen.V37.Gen.Msg.Log (p0 |> migrate_Pages_Log_Msg)

        Evergreen.V36.Gen.Msg.Login p0 ->
            Evergreen.V37.Gen.Msg.Login (p0 |> migrate_Pages_Login_Msg)

        Evergreen.V36.Gen.Msg.Register p0 ->
            Evergreen.V37.Gen.Msg.Register (p0 |> migrate_Pages_Register_Msg)

        Evergreen.V36.Gen.Msg.Channel__Id_ p0 ->
            Evergreen.V37.Gen.Msg.Channel__Id_ (p0 |> migrate_Pages_Channel_Id__Msg)

        Evergreen.V36.Gen.Msg.Ga__Email_ p0 ->
            Evergreen.V37.Gen.Msg.Ga__Email_ (p0 |> migrate_Pages_Ga_Email__Msg)

        Evergreen.V36.Gen.Msg.Playlist__Id_ p0 ->
            Evergreen.V37.Gen.Msg.Playlist__Id_ (p0 |> migrate_Pages_Playlist_Id__Msg)


migrate_Gen_Pages_Model : Evergreen.V36.Gen.Pages.Model -> Evergreen.V37.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V36.Gen.Pages.Msg -> Evergreen.V37.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Gen_Params_Channel_Id__Params : Evergreen.V36.Gen.Params.Channel.Id_.Params -> Evergreen.V37.Gen.Params.Channel.Id_.Params
migrate_Gen_Params_Channel_Id__Params old =
    old


migrate_Gen_Params_Ga_Email__Params : Evergreen.V36.Gen.Params.Ga.Email_.Params -> Evergreen.V37.Gen.Params.Ga.Email_.Params
migrate_Gen_Params_Ga_Email__Params old =
    old


migrate_Gen_Params_Playlist_Id__Params : Evergreen.V36.Gen.Params.Playlist.Id_.Params -> Evergreen.V37.Gen.Params.Playlist.Id_.Params
migrate_Gen_Params_Playlist_Id__Params old =
    old


migrate_Pages_Admin_Model : Evergreen.V36.Pages.Admin.Model -> Evergreen.V37.Pages.Admin.Model
migrate_Pages_Admin_Model old =
    old


migrate_Pages_Admin_Msg : Evergreen.V36.Pages.Admin.Msg -> Evergreen.V37.Pages.Admin.Msg
migrate_Pages_Admin_Msg old =
    case old of
        Evergreen.V36.Pages.Admin.ReplaceMe ->
            Evergreen.V37.Pages.Admin.ReplaceMe


migrate_Pages_Channel_Id__Model : Evergreen.V36.Pages.Channel.Id_.Model -> Evergreen.V37.Pages.Channel.Id_.Model
migrate_Pages_Channel_Id__Model old =
    old


migrate_Pages_Channel_Id__Msg : Evergreen.V36.Pages.Channel.Id_.Msg -> Evergreen.V37.Pages.Channel.Id_.Msg
migrate_Pages_Channel_Id__Msg old =
    case old of
        Evergreen.V36.Pages.Channel.Id_.GotChannelAndPlaylists p0 p1 p2 p3 ->
            Evergreen.V37.Pages.Channel.Id_.GotChannelAndPlaylists (p0 |> migrate_Api_YoutubeModel_Channel) p1 p2 p3

        Evergreen.V36.Pages.Channel.Id_.GetPlaylists ->
            Evergreen.V37.Pages.Channel.Id_.GetPlaylists

        Evergreen.V36.Pages.Channel.Id_.Schedule_UpdateSchedule p0 ->
            Evergreen.V37.Pages.Channel.Id_.Schedule_UpdateSchedule (p0 |> migrate_Api_YoutubeModel_Schedule)

        Evergreen.V36.Pages.Channel.Id_.MonitorPlaylist p0 p1 ->
            Evergreen.V37.Pages.Channel.Id_.MonitorPlaylist (p0 |> migrate_Api_YoutubeModel_Playlist) p1

        Evergreen.V36.Pages.Channel.Id_.Competitors p0 p1 ->
            Evergreen.V37.Pages.Channel.Id_.Competitors (p0 |> migrate_Api_YoutubeModel_Playlist) p1


migrate_Pages_End_Model : Evergreen.V36.Pages.End.Model -> Evergreen.V37.Pages.End.Model
migrate_Pages_End_Model old =
    old


migrate_Pages_End_Msg : Evergreen.V36.Pages.End.Msg -> Evergreen.V37.Pages.End.Msg
migrate_Pages_End_Msg old =
    case old of
        Evergreen.V36.Pages.End.ReplaceMe ->
            Evergreen.V37.Pages.End.ReplaceMe


migrate_Pages_Example_Model : Evergreen.V36.Pages.Example.Model -> Evergreen.V37.Pages.Example.Model
migrate_Pages_Example_Model old =
    old


migrate_Pages_Example_Msg : Evergreen.V36.Pages.Example.Msg -> Evergreen.V37.Pages.Example.Msg
migrate_Pages_Example_Msg old =
    case old of
        Evergreen.V36.Pages.Example.GotCredentials p0 ->
            Evergreen.V37.Pages.Example.GotCredentials p0

        Evergreen.V36.Pages.Example.GetChannels p0 ->
            Evergreen.V37.Pages.Example.GetChannels p0

        Evergreen.V36.Pages.Example.Tick p0 ->
            Evergreen.V37.Pages.Example.Tick p0


migrate_Pages_Ga_Email__Model : Evergreen.V36.Pages.Ga.Email_.Model -> Evergreen.V37.Pages.Ga.Email_.Model
migrate_Pages_Ga_Email__Model old =
    old


migrate_Pages_Ga_Email__Msg : Evergreen.V36.Pages.Ga.Email_.Msg -> Evergreen.V37.Pages.Ga.Email_.Msg
migrate_Pages_Ga_Email__Msg old =
    case old of
        Evergreen.V36.Pages.Ga.Email_.GotChannels p0 ->
            Evergreen.V37.Pages.Ga.Email_.GotChannels p0

        Evergreen.V36.Pages.Ga.Email_.GetChannels ->
            Evergreen.V37.Pages.Ga.Email_.GetChannels


migrate_Pages_Home__Model : Evergreen.V36.Pages.Home_.Model -> Evergreen.V37.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V36.Pages.Home_.Msg -> Evergreen.V37.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V36.Pages.Home_.Noop ->
            Evergreen.V37.Pages.Home_.Noop


migrate_Pages_Log_Model : Evergreen.V36.Pages.Log.Model -> Evergreen.V37.Pages.Log.Model
migrate_Pages_Log_Model old =
    { logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    , logIndex = old.logIndex
    }


migrate_Pages_Log_Msg : Evergreen.V36.Pages.Log.Msg -> Evergreen.V37.Pages.Log.Msg
migrate_Pages_Log_Msg old =
    case old of
        Evergreen.V36.Pages.Log.GotLogs p0 p1 ->
            Evergreen.V37.Pages.Log.GotLogs p0 (p1 |> List.map migrate_Api_Logging_LogEntry)

        Evergreen.V36.Pages.Log.GetLogPage p0 p1 ->
            Evergreen.V37.Pages.Log.GetLogPage p0 p1

        Evergreen.V36.Pages.Log.YeetLogs ->
            Evergreen.V37.Pages.Log.YeetLogs

        Evergreen.V36.Pages.Log.YeetVideos ->
            Evergreen.V37.Pages.Log.YeetVideos

        Evergreen.V36.Pages.Log.Batch_RefreshAccessTokens ->
            Evergreen.V37.Pages.Log.Batch_RefreshAccessTokens

        Evergreen.V36.Pages.Log.Batch_RefreshAllChannels ->
            Evergreen.V37.Pages.Log.Batch_RefreshAllChannels

        Evergreen.V36.Pages.Log.Batch_RefreshAllPlaylists ->
            Evergreen.V37.Pages.Log.Batch_RefreshAllPlaylists

        Evergreen.V36.Pages.Log.Batch_RefreshAllVideosFromPlaylists ->
            Evergreen.V37.Pages.Log.Batch_RefreshAllVideosFromPlaylists

        Evergreen.V36.Pages.Log.Batch_GetLiveVideoStreamData ->
            Evergreen.V37.Pages.Log.Batch_GetLiveVideoStreamData

        Evergreen.V36.Pages.Log.Batch_GetVideoStats ->
            Evergreen.V37.Pages.Log.Batch_GetVideoStats

        Evergreen.V36.Pages.Log.Batch_GetVideoDailyReports ->
            Evergreen.V37.Pages.Log.Batch_GetVideoDailyReports

        Evergreen.V36.Pages.Log.Batch_GetChatMessages ->
            Evergreen.V37.Pages.Log.Batch_GetChatMessages

        Evergreen.V36.Pages.Log.Batch_GetVideoStatisticsAtTime ->
            Evergreen.V37.Pages.Log.Batch_GetVideoStatisticsAtTime

        Evergreen.V36.Pages.Log.Batch_GetCompetitorVideos ->
            Evergreen.V37.Pages.Log.Batch_GetCompetitorVideos


migrate_Pages_Login_Field : Evergreen.V36.Pages.Login.Field -> Evergreen.V37.Pages.Login.Field
migrate_Pages_Login_Field old =
    case old of
        Evergreen.V36.Pages.Login.Email ->
            Evergreen.V37.Pages.Login.Email

        Evergreen.V36.Pages.Login.Password ->
            Evergreen.V37.Pages.Login.Password


migrate_Pages_Login_Model : Evergreen.V36.Pages.Login.Model -> Evergreen.V37.Pages.Login.Model
migrate_Pages_Login_Model old =
    old


migrate_Pages_Login_Msg : Evergreen.V36.Pages.Login.Msg -> Evergreen.V37.Pages.Login.Msg
migrate_Pages_Login_Msg old =
    case old of
        Evergreen.V36.Pages.Login.Updated p0 p1 ->
            Evergreen.V37.Pages.Login.Updated (p0 |> migrate_Pages_Login_Field) p1

        Evergreen.V36.Pages.Login.ToggledShowPassword ->
            Evergreen.V37.Pages.Login.ToggledShowPassword

        Evergreen.V36.Pages.Login.ClickedSubmit ->
            Evergreen.V37.Pages.Login.ClickedSubmit

        Evergreen.V36.Pages.Login.GotUser p0 ->
            Evergreen.V37.Pages.Login.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Playlist_Id__Model : Evergreen.V36.Pages.Playlist.Id_.Model -> Evergreen.V37.Pages.Playlist.Id_.Model
migrate_Pages_Playlist_Id__Model old =
    { playlistId = old.playlistId
    , playlistTitle = old.playlistTitle
    , videos = old.videos |> Dict.map (\k -> migrate_Api_YoutubeModel_Video)
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , videoChannels = old.videoChannels
    , playlists = old.playlists
    , videoStats = old.videoStats
    , competitorVideos = Dict.empty
    }


migrate_Pages_Playlist_Id__Msg : Evergreen.V36.Pages.Playlist.Id_.Msg -> Evergreen.V37.Pages.Playlist.Id_.Msg
migrate_Pages_Playlist_Id__Msg old =
    case old of
        Evergreen.V36.Pages.Playlist.Id_.GotVideos p0 p1 p2 p3 p4 p5 ->
            Evergreen.V37.Pages.Playlist.Id_.GotVideos p0
                (p1 |> Dict.map (\k -> migrate_Api_YoutubeModel_Video))
                p2
                p3
                p4
                p5
                Dict.empty

        Evergreen.V36.Pages.Playlist.Id_.GetVideos ->
            Evergreen.V37.Pages.Playlist.Id_.GetVideos


migrate_Pages_Register_Field : Evergreen.V36.Pages.Register.Field -> Evergreen.V37.Pages.Register.Field
migrate_Pages_Register_Field old =
    case old of
        Evergreen.V36.Pages.Register.Email ->
            Evergreen.V37.Pages.Register.Email

        Evergreen.V36.Pages.Register.Password ->
            Evergreen.V37.Pages.Register.Password


migrate_Pages_Register_Model : Evergreen.V36.Pages.Register.Model -> Evergreen.V37.Pages.Register.Model
migrate_Pages_Register_Model old =
    old


migrate_Pages_Register_Msg : Evergreen.V36.Pages.Register.Msg -> Evergreen.V37.Pages.Register.Msg
migrate_Pages_Register_Msg old =
    case old of
        Evergreen.V36.Pages.Register.Updated p0 p1 ->
            Evergreen.V37.Pages.Register.Updated (p0 |> migrate_Pages_Register_Field) p1

        Evergreen.V36.Pages.Register.ToggledShowPassword ->
            Evergreen.V37.Pages.Register.ToggledShowPassword

        Evergreen.V36.Pages.Register.ClickedSubmit ->
            Evergreen.V37.Pages.Register.ClickedSubmit

        Evergreen.V36.Pages.Register.GotUser p0 ->
            Evergreen.V37.Pages.Register.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Shared_Model : Evergreen.V36.Shared.Model -> Evergreen.V37.Shared.Model
migrate_Shared_Model old =
    { viewWidth = old.viewWidth
    , user = old.user |> Maybe.map migrate_Api_User_User
    , toastMessage = old.toastMessage
    }


migrate_Shared_Msg : Evergreen.V36.Shared.Msg -> Evergreen.V37.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V36.Shared.GotViewWidth p0 ->
            Evergreen.V37.Shared.GotViewWidth p0

        Evergreen.V36.Shared.Noop ->
            Evergreen.V37.Shared.Noop

        Evergreen.V36.Shared.SignInUser p0 ->
            Evergreen.V37.Shared.SignInUser (p0 |> migrate_Api_User_User)

        Evergreen.V36.Shared.SignOutUser ->
            Evergreen.V37.Shared.SignOutUser

        Evergreen.V36.Shared.ShowToastMessage p0 ->
            Evergreen.V37.Shared.ShowToastMessage p0

        Evergreen.V36.Shared.HideToastMessage p0 ->
            Evergreen.V37.Shared.HideToastMessage p0


migrate_Types_FrontendMsg : Evergreen.V36.Types.FrontendMsg -> Evergreen.V37.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V36.Types.ChangedUrl p0 ->
            Evergreen.V37.Types.ChangedUrl p0

        Evergreen.V36.Types.ClickedLink p0 ->
            Evergreen.V37.Types.ClickedLink p0

        Evergreen.V36.Types.Shared p0 ->
            Evergreen.V37.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V36.Types.Page p0 ->
            Evergreen.V37.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V36.Types.Noop ->
            Evergreen.V37.Types.Noop


migrate_Types_ToFrontend : Evergreen.V36.Types.ToFrontend -> Evergreen.V37.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V36.Types.PageMsg p0 ->
            Evergreen.V37.Types.PageMsg (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V36.Types.SharedMsg p0 ->
            Evergreen.V37.Types.SharedMsg (p0 |> migrate_Shared_Msg)

        Evergreen.V36.Types.NoOpToFrontend ->
            Evergreen.V37.Types.NoOpToFrontend
