module Evergreen.Migrate.V39 exposing (..)

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
import Evergreen.V38.Api.Data
import Evergreen.V38.Api.Logging
import Evergreen.V38.Api.User
import Evergreen.V38.Api.YoutubeModel
import Evergreen.V38.Gen.Model
import Evergreen.V38.Gen.Msg
import Evergreen.V38.Gen.Pages
import Evergreen.V38.Gen.Params.Channel.Id_
import Evergreen.V38.Gen.Params.Ga.Email_
import Evergreen.V38.Gen.Params.Playlist.Id_
import Evergreen.V38.Pages.Admin
import Evergreen.V38.Pages.Channel.Id_
import Evergreen.V38.Pages.End
import Evergreen.V38.Pages.Example
import Evergreen.V38.Pages.Ga.Email_
import Evergreen.V38.Pages.Home_
import Evergreen.V38.Pages.Log
import Evergreen.V38.Pages.Login
import Evergreen.V38.Pages.Playlist.Id_
import Evergreen.V38.Pages.Register
import Evergreen.V38.Shared
import Evergreen.V38.Types
import Evergreen.V39.Api.Data
import Evergreen.V39.Api.Logging
import Evergreen.V39.Api.User
import Evergreen.V39.Api.YoutubeModel
import Evergreen.V39.Gen.Model
import Evergreen.V39.Gen.Msg
import Evergreen.V39.Gen.Pages
import Evergreen.V39.Gen.Params.Channel.Id_
import Evergreen.V39.Gen.Params.Ga.Email_
import Evergreen.V39.Gen.Params.Playlist.Id_
import Evergreen.V39.Pages.Admin
import Evergreen.V39.Pages.Channel.Id_
import Evergreen.V39.Pages.End
import Evergreen.V39.Pages.Example
import Evergreen.V39.Pages.Ga.Email_
import Evergreen.V39.Pages.Home_
import Evergreen.V39.Pages.Log
import Evergreen.V39.Pages.Login
import Evergreen.V39.Pages.Playlist.Id_
import Evergreen.V39.Pages.Register
import Evergreen.V39.Shared
import Evergreen.V39.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe
import Http


frontendModel : Evergreen.V38.Types.FrontendModel -> ModelMigration Evergreen.V39.Types.FrontendModel Evergreen.V39.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V38.Types.BackendModel -> ModelMigration Evergreen.V39.Types.BackendModel Evergreen.V39.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V38.Types.FrontendMsg -> MsgMigration Evergreen.V39.Types.FrontendMsg Evergreen.V39.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V38.Types.ToBackend -> MsgMigration Evergreen.V39.Types.ToBackend Evergreen.V39.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V38.Types.BackendMsg -> MsgMigration Evergreen.V39.Types.BackendMsg Evergreen.V39.Types.BackendMsg
backendMsg old =
    MsgMigrated ( migrate_Types_BackendMsg old, Cmd.none )


toFrontend : Evergreen.V38.Types.ToFrontend -> MsgMigration Evergreen.V39.Types.ToFrontend Evergreen.V39.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V38.Types.BackendModel -> Evergreen.V39.Types.BackendModel
migrate_Types_BackendModel old =
    { users = old.users |> Dict.map (\k -> migrate_Api_User_UserFull)
    , authenticatedSessions = old.authenticatedSessions
    , incrementedInt = old.incrementedInt
    , logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    , clientCredentials = old.clientCredentials
    , channels = old.channels
    , channelAssociations = old.channelAssociations
    , playlists = old.playlists
    , competitors = old.competitors
    , schedules = old.schedules
    , videos = old.videos |> Dict.map (\k -> migrate_Api_YoutubeModel_Video)
    , videoStatisticsAtTime = old.videoStatisticsAtTime
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , channelHandleMap = []
    , apiCallCount = old.apiCallCount
    }


migrate_Types_FrontendModel : Evergreen.V38.Types.FrontendModel -> Evergreen.V39.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_Api_Data_Data : (value_old -> value_new) -> Evergreen.V38.Api.Data.Data value_old -> Evergreen.V39.Api.Data.Data value_new
migrate_Api_Data_Data migrate_value old =
    case old of
        Evergreen.V38.Api.Data.NotAsked ->
            Evergreen.V39.Api.Data.NotAsked

        Evergreen.V38.Api.Data.Loading ->
            Evergreen.V39.Api.Data.Loading

        Evergreen.V38.Api.Data.Failure p0 ->
            Evergreen.V39.Api.Data.Failure p0

        Evergreen.V38.Api.Data.Success p0 ->
            Evergreen.V39.Api.Data.Success (p0 |> migrate_value)


migrate_Api_Logging_LogEntry : Evergreen.V38.Api.Logging.LogEntry -> Evergreen.V39.Api.Logging.LogEntry
migrate_Api_Logging_LogEntry old =
    { message = old.message
    , timestamp = old.timestamp
    , logLevel = old.logLevel |> migrate_Api_Logging_LogLevel
    }


migrate_Api_Logging_LogLevel : Evergreen.V38.Api.Logging.LogLevel -> Evergreen.V39.Api.Logging.LogLevel
migrate_Api_Logging_LogLevel old =
    case old of
        Evergreen.V38.Api.Logging.Error ->
            Evergreen.V39.Api.Logging.Error

        Evergreen.V38.Api.Logging.Info ->
            Evergreen.V39.Api.Logging.Info

        Evergreen.V38.Api.Logging.Alert ->
            Evergreen.V39.Api.Logging.Alert


migrate_Api_User_Role : Evergreen.V38.Api.User.Role -> Evergreen.V39.Api.User.Role
migrate_Api_User_Role old =
    case old of
        Evergreen.V38.Api.User.Basic ->
            Evergreen.V39.Api.User.Basic

        Evergreen.V38.Api.User.Editor ->
            Evergreen.V39.Api.User.Editor

        Evergreen.V38.Api.User.Admin ->
            Evergreen.V39.Api.User.Admin


migrate_Api_User_User : Evergreen.V38.Api.User.User -> Evergreen.V39.Api.User.User
migrate_Api_User_User old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    }


migrate_Api_User_UserFull : Evergreen.V38.Api.User.UserFull -> Evergreen.V39.Api.User.UserFull
migrate_Api_User_UserFull old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    , passwordHash = old.passwordHash
    , salt = old.salt
    }


migrate_Api_YoutubeModel_Channel : Evergreen.V38.Api.YoutubeModel.Channel -> Evergreen.V39.Api.YoutubeModel.Channel
migrate_Api_YoutubeModel_Channel old =
    old


migrate_Api_YoutubeModel_DaysOfWeek : Evergreen.V38.Api.YoutubeModel.DaysOfWeek -> Evergreen.V39.Api.YoutubeModel.DaysOfWeek
migrate_Api_YoutubeModel_DaysOfWeek old =
    old


migrate_Api_YoutubeModel_LiveStatus : Evergreen.V38.Api.YoutubeModel.LiveStatus -> Evergreen.V39.Api.YoutubeModel.LiveStatus
migrate_Api_YoutubeModel_LiveStatus old =
    case old of
        Evergreen.V38.Api.YoutubeModel.Unknown ->
            Evergreen.V39.Api.YoutubeModel.Unknown

        Evergreen.V38.Api.YoutubeModel.Uploaded ->
            Evergreen.V39.Api.YoutubeModel.Uploaded

        Evergreen.V38.Api.YoutubeModel.Scheduled p0 ->
            Evergreen.V39.Api.YoutubeModel.Scheduled p0

        Evergreen.V38.Api.YoutubeModel.Expired ->
            Evergreen.V39.Api.YoutubeModel.Expired

        Evergreen.V38.Api.YoutubeModel.Old ->
            Evergreen.V39.Api.YoutubeModel.Old

        Evergreen.V38.Api.YoutubeModel.Live ->
            Evergreen.V39.Api.YoutubeModel.Live

        Evergreen.V38.Api.YoutubeModel.Ended p0 ->
            Evergreen.V39.Api.YoutubeModel.Ended p0

        Evergreen.V38.Api.YoutubeModel.Impossibru ->
            Evergreen.V39.Api.YoutubeModel.Impossibru


migrate_Api_YoutubeModel_Playlist : Evergreen.V38.Api.YoutubeModel.Playlist -> Evergreen.V39.Api.YoutubeModel.Playlist
migrate_Api_YoutubeModel_Playlist old =
    old


migrate_Api_YoutubeModel_Schedule : Evergreen.V38.Api.YoutubeModel.Schedule -> Evergreen.V39.Api.YoutubeModel.Schedule
migrate_Api_YoutubeModel_Schedule old =
    { playlistId = old.playlistId
    , hour = old.hour
    , minute = old.minute
    , days = old.days |> migrate_Api_YoutubeModel_DaysOfWeek
    }


migrate_Api_YoutubeModel_Video : Evergreen.V38.Api.YoutubeModel.Video -> Evergreen.V39.Api.YoutubeModel.Video
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


migrate_Gen_Model_Model : Evergreen.V38.Gen.Model.Model -> Evergreen.V39.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V38.Gen.Model.Redirecting_ ->
            Evergreen.V39.Gen.Model.Redirecting_

        Evergreen.V38.Gen.Model.Admin p0 p1 ->
            Evergreen.V39.Gen.Model.Admin p0 (p1 |> migrate_Pages_Admin_Model)

        Evergreen.V38.Gen.Model.End p0 p1 ->
            Evergreen.V39.Gen.Model.End p0 (p1 |> migrate_Pages_End_Model)

        Evergreen.V38.Gen.Model.Example p0 p1 ->
            Evergreen.V39.Gen.Model.Example p0 (p1 |> migrate_Pages_Example_Model)

        Evergreen.V38.Gen.Model.Home_ p0 p1 ->
            Evergreen.V39.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V38.Gen.Model.Log p0 p1 ->
            Evergreen.V39.Gen.Model.Log p0 (p1 |> migrate_Pages_Log_Model)

        Evergreen.V38.Gen.Model.Login p0 p1 ->
            Evergreen.V39.Gen.Model.Login p0 (p1 |> migrate_Pages_Login_Model)

        Evergreen.V38.Gen.Model.NotFound p0 ->
            Evergreen.V39.Gen.Model.NotFound p0

        Evergreen.V38.Gen.Model.Register p0 p1 ->
            Evergreen.V39.Gen.Model.Register p0 (p1 |> migrate_Pages_Register_Model)

        Evergreen.V38.Gen.Model.Channel__Id_ p0 p1 ->
            Evergreen.V39.Gen.Model.Channel__Id_ (p0 |> migrate_Gen_Params_Channel_Id__Params)
                (p1 |> migrate_Pages_Channel_Id__Model)

        Evergreen.V38.Gen.Model.Ga__Email_ p0 p1 ->
            Evergreen.V39.Gen.Model.Ga__Email_ (p0 |> migrate_Gen_Params_Ga_Email__Params)
                (p1 |> migrate_Pages_Ga_Email__Model)

        Evergreen.V38.Gen.Model.Playlist__Id_ p0 p1 ->
            Evergreen.V39.Gen.Model.Playlist__Id_ (p0 |> migrate_Gen_Params_Playlist_Id__Params)
                (p1 |> migrate_Pages_Playlist_Id__Model)


migrate_Gen_Msg_Msg : Evergreen.V38.Gen.Msg.Msg -> Evergreen.V39.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V38.Gen.Msg.Admin p0 ->
            Evergreen.V39.Gen.Msg.Admin (p0 |> migrate_Pages_Admin_Msg)

        Evergreen.V38.Gen.Msg.End p0 ->
            Evergreen.V39.Gen.Msg.End (p0 |> migrate_Pages_End_Msg)

        Evergreen.V38.Gen.Msg.Example p0 ->
            Evergreen.V39.Gen.Msg.Example (p0 |> migrate_Pages_Example_Msg)

        Evergreen.V38.Gen.Msg.Home_ p0 ->
            Evergreen.V39.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V38.Gen.Msg.Log p0 ->
            Evergreen.V39.Gen.Msg.Log (p0 |> migrate_Pages_Log_Msg)

        Evergreen.V38.Gen.Msg.Login p0 ->
            Evergreen.V39.Gen.Msg.Login (p0 |> migrate_Pages_Login_Msg)

        Evergreen.V38.Gen.Msg.Register p0 ->
            Evergreen.V39.Gen.Msg.Register (p0 |> migrate_Pages_Register_Msg)

        Evergreen.V38.Gen.Msg.Channel__Id_ p0 ->
            Evergreen.V39.Gen.Msg.Channel__Id_ (p0 |> migrate_Pages_Channel_Id__Msg)

        Evergreen.V38.Gen.Msg.Ga__Email_ p0 ->
            Evergreen.V39.Gen.Msg.Ga__Email_ (p0 |> migrate_Pages_Ga_Email__Msg)

        Evergreen.V38.Gen.Msg.Playlist__Id_ p0 ->
            Evergreen.V39.Gen.Msg.Playlist__Id_ (p0 |> migrate_Pages_Playlist_Id__Msg)


migrate_Gen_Pages_Model : Evergreen.V38.Gen.Pages.Model -> Evergreen.V39.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V38.Gen.Pages.Msg -> Evergreen.V39.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Gen_Params_Channel_Id__Params : Evergreen.V38.Gen.Params.Channel.Id_.Params -> Evergreen.V39.Gen.Params.Channel.Id_.Params
migrate_Gen_Params_Channel_Id__Params old =
    old


migrate_Gen_Params_Ga_Email__Params : Evergreen.V38.Gen.Params.Ga.Email_.Params -> Evergreen.V39.Gen.Params.Ga.Email_.Params
migrate_Gen_Params_Ga_Email__Params old =
    old


migrate_Gen_Params_Playlist_Id__Params : Evergreen.V38.Gen.Params.Playlist.Id_.Params -> Evergreen.V39.Gen.Params.Playlist.Id_.Params
migrate_Gen_Params_Playlist_Id__Params old =
    old


migrate_Pages_Admin_Model : Evergreen.V38.Pages.Admin.Model -> Evergreen.V39.Pages.Admin.Model
migrate_Pages_Admin_Model old =
    old


migrate_Pages_Admin_Msg : Evergreen.V38.Pages.Admin.Msg -> Evergreen.V39.Pages.Admin.Msg
migrate_Pages_Admin_Msg old =
    case old of
        Evergreen.V38.Pages.Admin.ReplaceMe ->
            Evergreen.V39.Pages.Admin.ReplaceMe


migrate_Pages_Channel_Id__Model : Evergreen.V38.Pages.Channel.Id_.Model -> Evergreen.V39.Pages.Channel.Id_.Model
migrate_Pages_Channel_Id__Model old =
    old


migrate_Pages_Channel_Id__Msg : Evergreen.V38.Pages.Channel.Id_.Msg -> Evergreen.V39.Pages.Channel.Id_.Msg
migrate_Pages_Channel_Id__Msg old =
    case old of
        Evergreen.V38.Pages.Channel.Id_.GotChannelAndPlaylists p0 p1 p2 p3 ->
            Evergreen.V39.Pages.Channel.Id_.GotChannelAndPlaylists (p0 |> migrate_Api_YoutubeModel_Channel) p1 p2 p3

        Evergreen.V38.Pages.Channel.Id_.GetPlaylists ->
            Evergreen.V39.Pages.Channel.Id_.GetPlaylists

        Evergreen.V38.Pages.Channel.Id_.Schedule_UpdateSchedule p0 ->
            Evergreen.V39.Pages.Channel.Id_.Schedule_UpdateSchedule (p0 |> migrate_Api_YoutubeModel_Schedule)

        Evergreen.V38.Pages.Channel.Id_.MonitorPlaylist p0 p1 ->
            Evergreen.V39.Pages.Channel.Id_.MonitorPlaylist (p0 |> migrate_Api_YoutubeModel_Playlist) p1

        Evergreen.V38.Pages.Channel.Id_.Competitors p0 p1 ->
            Evergreen.V39.Pages.Channel.Id_.Competitors (p0 |> migrate_Api_YoutubeModel_Playlist) p1


migrate_Pages_End_Model : Evergreen.V38.Pages.End.Model -> Evergreen.V39.Pages.End.Model
migrate_Pages_End_Model old =
    old


migrate_Pages_End_Msg : Evergreen.V38.Pages.End.Msg -> Evergreen.V39.Pages.End.Msg
migrate_Pages_End_Msg old =
    case old of
        Evergreen.V38.Pages.End.ReplaceMe ->
            Evergreen.V39.Pages.End.ReplaceMe


migrate_Pages_Example_Model : Evergreen.V38.Pages.Example.Model -> Evergreen.V39.Pages.Example.Model
migrate_Pages_Example_Model old =
    old


migrate_Pages_Example_Msg : Evergreen.V38.Pages.Example.Msg -> Evergreen.V39.Pages.Example.Msg
migrate_Pages_Example_Msg old =
    case old of
        Evergreen.V38.Pages.Example.GotCredentials p0 ->
            Evergreen.V39.Pages.Example.GotCredentials p0

        Evergreen.V38.Pages.Example.GetChannels p0 ->
            Evergreen.V39.Pages.Example.GetChannels p0

        Evergreen.V38.Pages.Example.Yeet p0 ->
            Evergreen.V39.Pages.Example.Yeet p0

        Evergreen.V38.Pages.Example.Tick p0 ->
            Evergreen.V39.Pages.Example.Tick p0


migrate_Pages_Ga_Email__Model : Evergreen.V38.Pages.Ga.Email_.Model -> Evergreen.V39.Pages.Ga.Email_.Model
migrate_Pages_Ga_Email__Model old =
    old


migrate_Pages_Ga_Email__Msg : Evergreen.V38.Pages.Ga.Email_.Msg -> Evergreen.V39.Pages.Ga.Email_.Msg
migrate_Pages_Ga_Email__Msg old =
    case old of
        Evergreen.V38.Pages.Ga.Email_.GotChannels p0 ->
            Evergreen.V39.Pages.Ga.Email_.GotChannels p0

        Evergreen.V38.Pages.Ga.Email_.GetChannels ->
            Evergreen.V39.Pages.Ga.Email_.GetChannels


migrate_Pages_Home__Model : Evergreen.V38.Pages.Home_.Model -> Evergreen.V39.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V38.Pages.Home_.Msg -> Evergreen.V39.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V38.Pages.Home_.Noop ->
            Evergreen.V39.Pages.Home_.Noop


migrate_Pages_Log_Model : Evergreen.V38.Pages.Log.Model -> Evergreen.V39.Pages.Log.Model
migrate_Pages_Log_Model old =
    { logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    , logIndex = old.logIndex
    }


migrate_Pages_Log_Msg : Evergreen.V38.Pages.Log.Msg -> Evergreen.V39.Pages.Log.Msg
migrate_Pages_Log_Msg old =
    case old of
        Evergreen.V38.Pages.Log.GotLogs p0 p1 ->
            Evergreen.V39.Pages.Log.GotLogs p0 (p1 |> List.map migrate_Api_Logging_LogEntry)

        Evergreen.V38.Pages.Log.GetLogPage p0 p1 ->
            Evergreen.V39.Pages.Log.GetLogPage p0 p1

        Evergreen.V38.Pages.Log.YeetLogs ->
            Evergreen.V39.Pages.Log.YeetLogs

        Evergreen.V38.Pages.Log.YeetVideos ->
            Evergreen.V39.Pages.Log.YeetVideos

        Evergreen.V38.Pages.Log.Batch_RefreshAccessTokens ->
            Evergreen.V39.Pages.Log.Batch_RefreshAccessTokens

        Evergreen.V38.Pages.Log.Batch_RefreshAllChannels ->
            Evergreen.V39.Pages.Log.Batch_RefreshAllChannels

        Evergreen.V38.Pages.Log.Batch_RefreshAllPlaylists ->
            Evergreen.V39.Pages.Log.Batch_RefreshAllPlaylists

        Evergreen.V38.Pages.Log.Batch_RefreshAllVideosFromPlaylists ->
            Evergreen.V39.Pages.Log.Batch_RefreshAllVideosFromPlaylists

        Evergreen.V38.Pages.Log.Batch_GetLiveVideoStreamData ->
            Evergreen.V39.Pages.Log.Batch_GetLiveVideoStreamData

        Evergreen.V38.Pages.Log.Batch_GetVideoStats ->
            Evergreen.V39.Pages.Log.Batch_GetVideoStats

        Evergreen.V38.Pages.Log.Batch_GetVideoDailyReports ->
            Evergreen.V39.Pages.Log.Batch_GetVideoDailyReports

        Evergreen.V38.Pages.Log.Batch_GetChatMessages ->
            Evergreen.V39.Pages.Log.Batch_GetChatMessages

        Evergreen.V38.Pages.Log.Batch_GetVideoStatisticsAtTime ->
            Evergreen.V39.Pages.Log.Batch_GetVideoStatisticsAtTime

        Evergreen.V38.Pages.Log.Batch_GetCompetitorVideos ->
            Evergreen.V39.Pages.Log.Batch_GetCompetitorVideos


migrate_Pages_Login_Field : Evergreen.V38.Pages.Login.Field -> Evergreen.V39.Pages.Login.Field
migrate_Pages_Login_Field old =
    case old of
        Evergreen.V38.Pages.Login.Email ->
            Evergreen.V39.Pages.Login.Email

        Evergreen.V38.Pages.Login.Password ->
            Evergreen.V39.Pages.Login.Password


migrate_Pages_Login_Model : Evergreen.V38.Pages.Login.Model -> Evergreen.V39.Pages.Login.Model
migrate_Pages_Login_Model old =
    old


migrate_Pages_Login_Msg : Evergreen.V38.Pages.Login.Msg -> Evergreen.V39.Pages.Login.Msg
migrate_Pages_Login_Msg old =
    case old of
        Evergreen.V38.Pages.Login.Updated p0 p1 ->
            Evergreen.V39.Pages.Login.Updated (p0 |> migrate_Pages_Login_Field) p1

        Evergreen.V38.Pages.Login.ToggledShowPassword ->
            Evergreen.V39.Pages.Login.ToggledShowPassword

        Evergreen.V38.Pages.Login.ClickedSubmit ->
            Evergreen.V39.Pages.Login.ClickedSubmit

        Evergreen.V38.Pages.Login.GotUser p0 ->
            Evergreen.V39.Pages.Login.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Playlist_Id__Model : Evergreen.V38.Pages.Playlist.Id_.Model -> Evergreen.V39.Pages.Playlist.Id_.Model
migrate_Pages_Playlist_Id__Model old =
    { playlistId = old.playlistId
    , playlistTitle = old.playlistTitle
    , videos = old.videos |> Dict.map (\k -> migrate_Api_YoutubeModel_Video)
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , videoChannels = old.videoChannels
    , playlists = old.playlists
    , videoStats = old.videoStats
    , competitorVideos = old.competitorVideos |> Dict.map (\_ v -> Dict.map (\_ v2 -> migrate_Api_YoutubeModel_Video v2) v)
    , currentIntTime = 0
    }


migrate_Pages_Playlist_Id__Msg : Evergreen.V38.Pages.Playlist.Id_.Msg -> Evergreen.V39.Pages.Playlist.Id_.Msg
migrate_Pages_Playlist_Id__Msg old =
    case old of
        Evergreen.V38.Pages.Playlist.Id_.GotVideos p0 p1 p2 p3 p4 p5 p6 ->
            Evergreen.V39.Pages.Playlist.Id_.GotVideos p0
                (p1 |> Dict.map (\k -> migrate_Api_YoutubeModel_Video))
                p2
                p3
                p4
                p5
                (p6 |> Dict.map (\_ v -> Dict.map (\_ v2 -> migrate_Api_YoutubeModel_Video v2) v))

        Evergreen.V38.Pages.Playlist.Id_.GetVideos ->
            Evergreen.V39.Pages.Playlist.Id_.GetVideos


migrate_Pages_Register_Field : Evergreen.V38.Pages.Register.Field -> Evergreen.V39.Pages.Register.Field
migrate_Pages_Register_Field old =
    case old of
        Evergreen.V38.Pages.Register.Email ->
            Evergreen.V39.Pages.Register.Email

        Evergreen.V38.Pages.Register.Password ->
            Evergreen.V39.Pages.Register.Password


migrate_Pages_Register_Model : Evergreen.V38.Pages.Register.Model -> Evergreen.V39.Pages.Register.Model
migrate_Pages_Register_Model old =
    old


migrate_Pages_Register_Msg : Evergreen.V38.Pages.Register.Msg -> Evergreen.V39.Pages.Register.Msg
migrate_Pages_Register_Msg old =
    case old of
        Evergreen.V38.Pages.Register.Updated p0 p1 ->
            Evergreen.V39.Pages.Register.Updated (p0 |> migrate_Pages_Register_Field) p1

        Evergreen.V38.Pages.Register.ToggledShowPassword ->
            Evergreen.V39.Pages.Register.ToggledShowPassword

        Evergreen.V38.Pages.Register.ClickedSubmit ->
            Evergreen.V39.Pages.Register.ClickedSubmit

        Evergreen.V38.Pages.Register.GotUser p0 ->
            Evergreen.V39.Pages.Register.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Shared_Model : Evergreen.V38.Shared.Model -> Evergreen.V39.Shared.Model
migrate_Shared_Model old =
    { viewWidth = old.viewWidth
    , user = old.user |> Maybe.map migrate_Api_User_User
    , toastMessage = old.toastMessage
    }


migrate_Shared_Msg : Evergreen.V38.Shared.Msg -> Evergreen.V39.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V38.Shared.GotViewWidth p0 ->
            Evergreen.V39.Shared.GotViewWidth p0

        Evergreen.V38.Shared.Noop ->
            Evergreen.V39.Shared.Noop

        Evergreen.V38.Shared.SignInUser p0 ->
            Evergreen.V39.Shared.SignInUser (p0 |> migrate_Api_User_User)

        Evergreen.V38.Shared.SignOutUser ->
            Evergreen.V39.Shared.SignOutUser

        Evergreen.V38.Shared.ShowToastMessage p0 ->
            Evergreen.V39.Shared.ShowToastMessage p0

        Evergreen.V38.Shared.HideToastMessage p0 ->
            Evergreen.V39.Shared.HideToastMessage p0


migrate_Types_BackendMsg : Evergreen.V38.Types.BackendMsg -> Evergreen.V39.Types.BackendMsg
migrate_Types_BackendMsg old =
    case old of
        Evergreen.V38.Types.OnConnect p0 p1 ->
            Evergreen.V39.Types.OnConnect p0 p1

        Evergreen.V38.Types.AuthenticateSession p0 p1 p2 p3 ->
            Evergreen.V39.Types.AuthenticateSession p0 p1 (p2 |> migrate_Api_User_User) p3

        Evergreen.V38.Types.VerifySession p0 p1 p2 ->
            Evergreen.V39.Types.VerifySession p0 p1 p2

        Evergreen.V38.Types.RegisterUser p0 p1 p2 p3 ->
            Evergreen.V39.Types.RegisterUser p0 p1 p2 p3

        Evergreen.V38.Types.Log_ p0 p1 p2 ->
            Evergreen.V39.Types.Log_ p0 (p1 |> migrate_Api_Logging_LogLevel) p2

        Evergreen.V38.Types.GotFreshAccessTokenWithTime p0 p1 p2 ->
            Evergreen.V39.Types.GotFreshAccessTokenWithTime p0 p1 p2

        Evergreen.V38.Types.Batch_RefreshAccessTokens p0 ->
            Evergreen.V39.Types.Batch_RefreshAccessTokens p0

        Evergreen.V38.Types.Batch_RefreshAllChannels p0 ->
            Evergreen.V39.Types.Batch_RefreshAllChannels p0

        Evergreen.V38.Types.Batch_RefreshAllPlaylists p0 ->
            Evergreen.V39.Types.Batch_RefreshAllPlaylists p0

        Evergreen.V38.Types.Batch_RefreshAllVideosFromPlaylists p0 ->
            Evergreen.V39.Types.Batch_RefreshAllVideosFromPlaylists p0

        Evergreen.V38.Types.Batch_GetLiveVideoStreamData p0 ->
            Evergreen.V39.Types.Batch_GetLiveVideoStreamData p0

        Evergreen.V38.Types.Batch_GetChatMessages p0 ->
            Evergreen.V39.Types.Batch_GetChatMessages p0

        Evergreen.V38.Types.Batch_GetVideoStats p0 ->
            Evergreen.V39.Types.Batch_GetVideoStats p0

        Evergreen.V38.Types.Batch_GetVideoDailyReports p0 ->
            Evergreen.V39.Types.Batch_GetVideoDailyReports p0

        Evergreen.V38.Types.Batch_GetVideoStatisticsAtTime p0 ->
            Evergreen.V39.Types.Batch_GetVideoStatisticsAtTime p0

        Evergreen.V38.Types.Batch_GetCompetitorVideos p0 ->
            Evergreen.V39.Types.Batch_GetCompetitorVideos p0

        Evergreen.V38.Types.GetChannelId p0 p1 p2 ->
            Evergreen.V39.Types.GetChannelId p0


        Evergreen.V38.Types.GetAccessToken p0 p1 ->
            Evergreen.V39.Types.GetAccessToken p0 p1

        Evergreen.V38.Types.GotAccessToken p0 p1 p2 ->
            Evergreen.V39.Types.GotAccessToken p0 p1 p2

        Evergreen.V38.Types.GetChannelsByCredential p0 ->
            Evergreen.V39.Types.GetChannelsByCredential p0

        Evergreen.V38.Types.GotChannels p0 p1 ->
            Evergreen.V39.Types.GotChannels p0 p1

        Evergreen.V38.Types.GetPlaylistsByChannel p0 ->
            Evergreen.V39.Types.GetPlaylistsByChannel p0

        Evergreen.V38.Types.GotPlaylists p0 p1 ->
            Evergreen.V39.Types.GotPlaylists p0 p1

        Evergreen.V38.Types.GetVideosByPlaylist p0 p1 ->
            Evergreen.V39.Types.GetVideosByPlaylist p0 p1

        Evergreen.V38.Types.GotVideosFromPlaylist p0 p1 ->
            Evergreen.V39.Types.GotVideosFromPlaylist p0 p1

        Evergreen.V38.Types.GotLiveVideoStreamData p0 p1 p2 ->
            Evergreen.V39.Types.GotLiveVideoStreamData p0 p1 p2

        Evergreen.V38.Types.GotVideoStatsOnConclusion p0 p1 p2 ->
            Evergreen.V39.Types.GotVideoStatsOnConclusion p0 p1 p2

        Evergreen.V38.Types.GotVideoStatsAfter24Hrs p0 p1 p2 ->
            Evergreen.V39.Types.GotVideoStatsAfter24Hrs p0 p1 p2

        Evergreen.V38.Types.GotVideoStatsOnTheHour p0 p1 p2 ->
            Evergreen.V39.Types.GotVideoStatsOnTheHour p0 p1 p2

        Evergreen.V38.Types.GotChatMessages p0 p1 ->
            Evergreen.V39.Types.GotChatMessages p0 p1

        Evergreen.V38.Types.GotVideoDailyReport p0 p1 ->
            Evergreen.V39.Types.GotVideoDailyReport p0 p1

        Evergreen.V38.Types.GotChannelId p0 p1 p2 p3 ->
            Evergreen.V39.Types.GotChannelId p0
                (Result.Err Http.Timeout)


        Evergreen.V38.Types.GotCompetitorVideos p0 p1 p2 ->
            Evergreen.V39.Types.GotCompetitorVideos p0 p1 p2

        Evergreen.V38.Types.NoOpBackendMsg ->
            Evergreen.V39.Types.NoOpBackendMsg



migrate_Types_FrontendMsg : Evergreen.V38.Types.FrontendMsg -> Evergreen.V39.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V38.Types.ChangedUrl p0 ->
            Evergreen.V39.Types.ChangedUrl p0

        Evergreen.V38.Types.ClickedLink p0 ->
            Evergreen.V39.Types.ClickedLink p0

        Evergreen.V38.Types.Shared p0 ->
            Evergreen.V39.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V38.Types.Page p0 ->
            Evergreen.V39.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V38.Types.Noop ->
            Evergreen.V39.Types.Noop


migrate_Types_ToFrontend : Evergreen.V38.Types.ToFrontend -> Evergreen.V39.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V38.Types.PageMsg p0 ->
            Evergreen.V39.Types.PageMsg (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V38.Types.SharedMsg p0 ->
            Evergreen.V39.Types.SharedMsg (p0 |> migrate_Shared_Msg)

        Evergreen.V38.Types.NoOpToFrontend ->
            Evergreen.V39.Types.NoOpToFrontend
