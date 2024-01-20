module Evergreen.Migrate.V48 exposing (..)

{-| This migration file was automatically generated by the lamdera compiler.

It includes:

  - A migration for each of the 6 Lamdera core types that has changed
  - A function named `migrate_ModuleName_TypeName` for each changed/custom type

Expect to see:

  - `lementеd` values as placeholders wherever I was unable to figure out a clear migration path for you
  - `@NOTICE` comments for things you should know about, i.e. new custom type constructors that won't get any
    value mappings from the old type by default

You can edit this file however you wish! It won't be generated again.

See <https://dashboard.lamdera.app/docs/evergreen> for more info.

-}

import Dict
import Evergreen.V40.Api.Data
import Evergreen.V40.Api.Logging
import Evergreen.V40.Api.User
import Evergreen.V40.Api.YoutubeModel
import Evergreen.V40.Bridge
import Evergreen.V40.Gen.Model
import Evergreen.V40.Gen.Msg
import Evergreen.V40.Gen.Pages
import Evergreen.V40.Gen.Params.Channel.Id_
import Evergreen.V40.Gen.Params.Ga.Email_
import Evergreen.V40.Gen.Params.Playlist.Id_
import Evergreen.V40.Gen.Params.Video.Id_
import Evergreen.V40.Pages.Admin
import Evergreen.V40.Pages.Channel.Id_
import Evergreen.V40.Pages.End
import Evergreen.V40.Pages.Example
import Evergreen.V40.Pages.Ga.Email_
import Evergreen.V40.Pages.Home_
import Evergreen.V40.Pages.Log
import Evergreen.V40.Pages.Login
import Evergreen.V40.Pages.Playlist.Id_
import Evergreen.V40.Pages.Register
import Evergreen.V40.Pages.Video.Id_
import Evergreen.V40.Shared
import Evergreen.V40.Types
import Evergreen.V48.Api.Data
import Evergreen.V48.Api.Logging
import Evergreen.V48.Api.User
import Evergreen.V48.Api.YoutubeModel
import Evergreen.V48.Bridge
import Evergreen.V48.Gen.Model
import Evergreen.V48.Gen.Msg
import Evergreen.V48.Gen.Pages
import Evergreen.V48.Gen.Params.Channel.Id_
import Evergreen.V48.Gen.Params.Ga.Email_
import Evergreen.V48.Gen.Params.Playlist.Id_
import Evergreen.V48.Gen.Params.Video.Id_
import Evergreen.V48.Pages.Admin
import Evergreen.V48.Pages.Channel.Id_
import Evergreen.V48.Pages.End
import Evergreen.V48.Pages.Example
import Evergreen.V48.Pages.Ga.Email_
import Evergreen.V48.Pages.Home_
import Evergreen.V48.Pages.Log
import Evergreen.V48.Pages.Login
import Evergreen.V48.Pages.Playlist.Id_
import Evergreen.V48.Pages.Register
import Evergreen.V48.Pages.Video.Id_
import Evergreen.V48.Shared
import Evergreen.V48.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe
import Set


frontendModel : Evergreen.V40.Types.FrontendModel -> ModelMigration Evergreen.V48.Types.FrontendModel Evergreen.V48.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V40.Types.BackendModel -> ModelMigration Evergreen.V48.Types.BackendModel Evergreen.V48.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V40.Types.FrontendMsg -> MsgMigration Evergreen.V48.Types.FrontendMsg Evergreen.V48.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V40.Types.ToBackend -> MsgMigration Evergreen.V48.Types.ToBackend Evergreen.V48.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V40.Types.BackendMsg -> MsgMigration Evergreen.V48.Types.BackendMsg Evergreen.V48.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V40.Types.ToFrontend -> MsgMigration Evergreen.V48.Types.ToFrontend Evergreen.V48.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V40.Types.BackendModel -> Evergreen.V48.Types.BackendModel
migrate_Types_BackendModel old =
    { users = old.users |> Dict.map (\k -> migrate_Api_User_UserFull)
    , authenticatedSessions = old.authenticatedSessions
    , incrementedInt = old.incrementedInt
    , logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    , clientCredentials = old.clientCredentials
    , channels = old.channels
    , channelAssociations = old.channelAssociations
    , playlists = old.playlists |> Dict.map (\k -> migrate_Api_YoutubeModel_Playlist)
    , competitors = old.competitors
    , schedules = old.schedules
    , videos = old.videos |> Dict.map (\k -> migrate_Api_YoutubeModel_Video)
    , videoStatisticsAtTime = old.videoStatisticsAtTime
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , channelHandleMap = old.channelHandleMap
    , apiCallCount = old.apiCallCount
    }


migrate_Types_FrontendModel : Evergreen.V40.Types.FrontendModel -> Evergreen.V48.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_Types_ToBackend : Evergreen.V40.Types.ToBackend -> Evergreen.V48.Types.ToBackend
migrate_Types_ToBackend old =
    old |> migrate_Bridge_ToBackend


migrate_Api_Data_Data : (value_old -> value_new) -> Evergreen.V40.Api.Data.Data value_old -> Evergreen.V48.Api.Data.Data value_new
migrate_Api_Data_Data migrate_value old =
    case old of
        Evergreen.V40.Api.Data.NotAsked ->
            Evergreen.V48.Api.Data.NotAsked

        Evergreen.V40.Api.Data.Loading ->
            Evergreen.V48.Api.Data.Loading

        Evergreen.V40.Api.Data.Failure p0 ->
            Evergreen.V48.Api.Data.Failure p0

        Evergreen.V40.Api.Data.Success p0 ->
            Evergreen.V48.Api.Data.Success (p0 |> migrate_value)


migrate_Api_Logging_LogEntry : Evergreen.V40.Api.Logging.LogEntry -> Evergreen.V48.Api.Logging.LogEntry
migrate_Api_Logging_LogEntry old =
    { message = old.message
    , timestamp = old.timestamp
    , logLevel = old.logLevel |> migrate_Api_Logging_LogLevel
    }


migrate_Api_Logging_LogLevel : Evergreen.V40.Api.Logging.LogLevel -> Evergreen.V48.Api.Logging.LogLevel
migrate_Api_Logging_LogLevel old =
    case old of
        Evergreen.V40.Api.Logging.Error ->
            Evergreen.V48.Api.Logging.Error

        Evergreen.V40.Api.Logging.Info ->
            Evergreen.V48.Api.Logging.Info

        Evergreen.V40.Api.Logging.Alert ->
            Evergreen.V48.Api.Logging.Alert


migrate_Api_User_Role : Evergreen.V40.Api.User.Role -> Evergreen.V48.Api.User.Role
migrate_Api_User_Role old =
    case old of
        Evergreen.V40.Api.User.Basic ->
            Evergreen.V48.Api.User.Basic

        Evergreen.V40.Api.User.Editor ->
            Evergreen.V48.Api.User.Editor

        Evergreen.V40.Api.User.Admin ->
            Evergreen.V48.Api.User.Admin


migrate_Api_User_User : Evergreen.V40.Api.User.User -> Evergreen.V48.Api.User.User
migrate_Api_User_User old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    }


migrate_Api_User_UserFull : Evergreen.V40.Api.User.UserFull -> Evergreen.V48.Api.User.UserFull
migrate_Api_User_UserFull old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    , passwordHash = old.passwordHash
    , salt = old.salt
    }


migrate_Api_YoutubeModel_Channel : Evergreen.V40.Api.YoutubeModel.Channel -> Evergreen.V48.Api.YoutubeModel.Channel
migrate_Api_YoutubeModel_Channel old =
    old


migrate_Api_YoutubeModel_DaysOfWeek : Evergreen.V40.Api.YoutubeModel.DaysOfWeek -> Evergreen.V48.Api.YoutubeModel.DaysOfWeek
migrate_Api_YoutubeModel_DaysOfWeek old =
    old


migrate_Api_YoutubeModel_LiveStatus : Evergreen.V40.Api.YoutubeModel.LiveStatus -> Evergreen.V48.Api.YoutubeModel.LiveStatus
migrate_Api_YoutubeModel_LiveStatus old =
    case old of
        Evergreen.V40.Api.YoutubeModel.Unknown ->
            Evergreen.V48.Api.YoutubeModel.Unknown

        Evergreen.V40.Api.YoutubeModel.Uploaded ->
            Evergreen.V48.Api.YoutubeModel.Uploaded

        Evergreen.V40.Api.YoutubeModel.Scheduled p0 ->
            Evergreen.V48.Api.YoutubeModel.Scheduled p0

        Evergreen.V40.Api.YoutubeModel.Expired ->
            Evergreen.V48.Api.YoutubeModel.Expired

        Evergreen.V40.Api.YoutubeModel.Old ->
            Evergreen.V48.Api.YoutubeModel.Old

        Evergreen.V40.Api.YoutubeModel.Live ->
            Evergreen.V48.Api.YoutubeModel.Live

        Evergreen.V40.Api.YoutubeModel.Ended p0 ->
            Evergreen.V48.Api.YoutubeModel.Ended p0

        Evergreen.V40.Api.YoutubeModel.Impossibru ->
            Evergreen.V48.Api.YoutubeModel.Impossibru


migrate_Api_YoutubeModel_Playlist : Evergreen.V40.Api.YoutubeModel.Playlist -> Evergreen.V48.Api.YoutubeModel.Playlist
migrate_Api_YoutubeModel_Playlist old =
    { id = old.id
    , title = old.title
    , description = old.description
    , channelId = old.channelId
    , monitor = old.monitor
    , competitorHandles = old.competitorHandles
    , competitorIds = Set.empty
    }


migrate_Api_YoutubeModel_Schedule : Evergreen.V40.Api.YoutubeModel.Schedule -> Evergreen.V48.Api.YoutubeModel.Schedule
migrate_Api_YoutubeModel_Schedule old =
    { playlistId = old.playlistId
    , hour = old.hour
    , minute = old.minute
    , days = old.days |> migrate_Api_YoutubeModel_DaysOfWeek
    }


migrate_Api_YoutubeModel_Video : Evergreen.V40.Api.YoutubeModel.Video -> Evergreen.V48.Api.YoutubeModel.Video
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


migrate_Bridge_ToBackend : Evergreen.V40.Bridge.ToBackend -> Evergreen.V48.Bridge.ToBackend
migrate_Bridge_ToBackend old =
    case old of
        Evergreen.V40.Bridge.AttemptRegistration p0 ->
            Evergreen.V48.Bridge.AttemptRegistration p0

        Evergreen.V40.Bridge.AttemptSignIn p0 ->
            Evergreen.V48.Bridge.AttemptSignIn p0

        Evergreen.V40.Bridge.AttemptSignOut ->
            Evergreen.V48.Bridge.AttemptSignOut

        Evergreen.V40.Bridge.AttemptGetCredentials ->
            Evergreen.V48.Bridge.AttemptGetCredentials

        Evergreen.V40.Bridge.AttemptGetChannels p0 ->
            Evergreen.V48.Bridge.AttemptGetChannels p0

        Evergreen.V40.Bridge.AttemptGetVideos p0 ->
            Evergreen.V48.Bridge.AttemptGetVideos p0

        Evergreen.V40.Bridge.AttemptYeetCredentials p0 ->
            Evergreen.V48.Bridge.AttemptYeetCredentials p0

        Evergreen.V40.Bridge.FetchChannelsFromYoutube p0 ->
            Evergreen.V48.Bridge.FetchChannelsFromYoutube p0

        Evergreen.V40.Bridge.FetchPlaylistsFromYoutube p0 ->
            Evergreen.V48.Bridge.FetchPlaylistsFromYoutube p0

        Evergreen.V40.Bridge.FetchVideosFromYoutube p0 ->
            Evergreen.V48.Bridge.FetchVideosFromYoutube p0

        Evergreen.V40.Bridge.AttemptGetChannelAndPlaylists p0 ->
            Evergreen.V48.Bridge.AttemptGetChannelAndPlaylists p0

        Evergreen.V40.Bridge.AttemptGetLogs p0 p1 ->
            Evergreen.V48.Bridge.AttemptGetLogs p0 p1

        Evergreen.V40.Bridge.AttemptYeetLogs ->
            Evergreen.V48.Bridge.AttemptYeetLogs

        Evergreen.V40.Bridge.AttemptYeetVideos ->
            Evergreen.V48.Bridge.AttemptYeetVideos

        Evergreen.V40.Bridge.AttemptGetVideoDetails p0 ->
            Evergreen.V48.Bridge.AttemptGetVideoDetails p0

        Evergreen.V40.Bridge.AttemptBatch_RefreshAccessTokens ->
            Evergreen.V48.Bridge.AttemptBatch_RefreshAccessTokens

        Evergreen.V40.Bridge.AttemptBatch_RefreshAllChannels ->
            Evergreen.V48.Bridge.AttemptBatch_RefreshAllChannels

        Evergreen.V40.Bridge.AttemptBatch_RefreshAllPlaylists ->
            Evergreen.V48.Bridge.AttemptBatch_RefreshAllPlaylists

        Evergreen.V40.Bridge.AttemptBatch_RefreshAllVideosFromPlaylists ->
            Evergreen.V48.Bridge.AttemptBatch_RefreshAllVideosFromPlaylists

        Evergreen.V40.Bridge.AttemptBatch_GetLiveVideoStreamData ->
            Evergreen.V48.Bridge.AttemptBatch_GetLiveVideoStreamData

        Evergreen.V40.Bridge.AttemptBatch_GetVideoStats ->
            Evergreen.V48.Bridge.AttemptBatch_GetVideoStats

        Evergreen.V40.Bridge.AttemptBatch_GetVideoDailyReports ->
            Evergreen.V48.Bridge.AttemptBatch_GetVideoDailyReports

        Evergreen.V40.Bridge.AttemptBatch_GetChatMessages ->
            Evergreen.V48.Bridge.AttemptBatch_GetChatMessages

        Evergreen.V40.Bridge.AttemptBatch_GetVideoStatisticsAtTime ->
            Evergreen.V48.Bridge.AttemptBatch_GetVideoStatisticsAtTime

        Evergreen.V40.Bridge.AttemptBatch_GetCompetitorVideos ->
            Evergreen.V48.Bridge.AttemptBatch_GetCompetitorVideos

        Evergreen.V40.Bridge.UpdateSchedule p0 ->
            Evergreen.V48.Bridge.UpdateSchedule (p0 |> migrate_Api_YoutubeModel_Schedule)

        Evergreen.V40.Bridge.UpdatePlaylist p0 ->
            Evergreen.V48.Bridge.UpdatePlaylist (p0 |> migrate_Api_YoutubeModel_Playlist)

        Evergreen.V40.Bridge.NoOpToBackend ->
            Evergreen.V48.Bridge.NoOpToBackend


migrate_Gen_Model_Model : Evergreen.V40.Gen.Model.Model -> Evergreen.V48.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V40.Gen.Model.Redirecting_ ->
            Evergreen.V48.Gen.Model.Redirecting_

        Evergreen.V40.Gen.Model.Admin p0 p1 ->
            Evergreen.V48.Gen.Model.Admin p0 (p1 |> migrate_Pages_Admin_Model)

        Evergreen.V40.Gen.Model.End p0 p1 ->
            Evergreen.V48.Gen.Model.End p0 (p1 |> migrate_Pages_End_Model)

        Evergreen.V40.Gen.Model.Example p0 p1 ->
            Evergreen.V48.Gen.Model.Example p0 (p1 |> migrate_Pages_Example_Model)

        Evergreen.V40.Gen.Model.Home_ p0 p1 ->
            Evergreen.V48.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V40.Gen.Model.Log p0 p1 ->
            Evergreen.V48.Gen.Model.Log p0 (p1 |> migrate_Pages_Log_Model)

        Evergreen.V40.Gen.Model.Login p0 p1 ->
            Evergreen.V48.Gen.Model.Login p0 (p1 |> migrate_Pages_Login_Model)

        Evergreen.V40.Gen.Model.NotFound p0 ->
            Evergreen.V48.Gen.Model.NotFound p0

        Evergreen.V40.Gen.Model.Register p0 p1 ->
            Evergreen.V48.Gen.Model.Register p0 (p1 |> migrate_Pages_Register_Model)

        Evergreen.V40.Gen.Model.Channel__Id_ p0 p1 ->
            Evergreen.V48.Gen.Model.Channel__Id_ (p0 |> migrate_Gen_Params_Channel_Id__Params)
                (p1 |> migrate_Pages_Channel_Id__Model)

        Evergreen.V40.Gen.Model.Ga__Email_ p0 p1 ->
            Evergreen.V48.Gen.Model.Ga__Email_ (p0 |> migrate_Gen_Params_Ga_Email__Params)
                (p1 |> migrate_Pages_Ga_Email__Model)

        Evergreen.V40.Gen.Model.Playlist__Id_ p0 p1 ->
            Evergreen.V48.Gen.Model.Playlist__Id_ (p0 |> migrate_Gen_Params_Playlist_Id__Params)
                (p1 |> migrate_Pages_Playlist_Id__Model)

        Evergreen.V40.Gen.Model.Video__Id_ p0 p1 ->
            Evergreen.V48.Gen.Model.Video__Id_ (p0 |> migrate_Gen_Params_Video_Id__Params)
                (p1 |> migrate_Pages_Video_Id__Model)


migrate_Gen_Msg_Msg : Evergreen.V40.Gen.Msg.Msg -> Evergreen.V48.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V40.Gen.Msg.Admin p0 ->
            Evergreen.V48.Gen.Msg.Admin (p0 |> migrate_Pages_Admin_Msg)

        Evergreen.V40.Gen.Msg.End p0 ->
            Evergreen.V48.Gen.Msg.End (p0 |> migrate_Pages_End_Msg)

        Evergreen.V40.Gen.Msg.Example p0 ->
            Evergreen.V48.Gen.Msg.Example (p0 |> migrate_Pages_Example_Msg)

        Evergreen.V40.Gen.Msg.Home_ p0 ->
            Evergreen.V48.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V40.Gen.Msg.Log p0 ->
            Evergreen.V48.Gen.Msg.Log (p0 |> migrate_Pages_Log_Msg)

        Evergreen.V40.Gen.Msg.Login p0 ->
            Evergreen.V48.Gen.Msg.Login (p0 |> migrate_Pages_Login_Msg)

        Evergreen.V40.Gen.Msg.Register p0 ->
            Evergreen.V48.Gen.Msg.Register (p0 |> migrate_Pages_Register_Msg)

        Evergreen.V40.Gen.Msg.Channel__Id_ p0 ->
            Evergreen.V48.Gen.Msg.Channel__Id_ (p0 |> migrate_Pages_Channel_Id__Msg)

        Evergreen.V40.Gen.Msg.Ga__Email_ p0 ->
            Evergreen.V48.Gen.Msg.Ga__Email_ (p0 |> migrate_Pages_Ga_Email__Msg)

        Evergreen.V40.Gen.Msg.Playlist__Id_ p0 ->
            Evergreen.V48.Gen.Msg.Playlist__Id_ (p0 |> migrate_Pages_Playlist_Id__Msg)

        Evergreen.V40.Gen.Msg.Video__Id_ p0 ->
            Evergreen.V48.Gen.Msg.Video__Id_ (p0 |> migrate_Pages_Video_Id__Msg)


migrate_Gen_Pages_Model : Evergreen.V40.Gen.Pages.Model -> Evergreen.V48.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V40.Gen.Pages.Msg -> Evergreen.V48.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Gen_Params_Channel_Id__Params : Evergreen.V40.Gen.Params.Channel.Id_.Params -> Evergreen.V48.Gen.Params.Channel.Id_.Params
migrate_Gen_Params_Channel_Id__Params old =
    old


migrate_Gen_Params_Ga_Email__Params : Evergreen.V40.Gen.Params.Ga.Email_.Params -> Evergreen.V48.Gen.Params.Ga.Email_.Params
migrate_Gen_Params_Ga_Email__Params old =
    old


migrate_Gen_Params_Playlist_Id__Params : Evergreen.V40.Gen.Params.Playlist.Id_.Params -> Evergreen.V48.Gen.Params.Playlist.Id_.Params
migrate_Gen_Params_Playlist_Id__Params old =
    old


migrate_Gen_Params_Video_Id__Params : Evergreen.V40.Gen.Params.Video.Id_.Params -> Evergreen.V48.Gen.Params.Video.Id_.Params
migrate_Gen_Params_Video_Id__Params old =
    old


migrate_Pages_Admin_Model : Evergreen.V40.Pages.Admin.Model -> Evergreen.V48.Pages.Admin.Model
migrate_Pages_Admin_Model old =
    old


migrate_Pages_Admin_Msg : Evergreen.V40.Pages.Admin.Msg -> Evergreen.V48.Pages.Admin.Msg
migrate_Pages_Admin_Msg old =
    case old of
        Evergreen.V40.Pages.Admin.ReplaceMe ->
            Evergreen.V48.Pages.Admin.ReplaceMe


migrate_Pages_Channel_Id__Model : Evergreen.V40.Pages.Channel.Id_.Model -> Evergreen.V48.Pages.Channel.Id_.Model
migrate_Pages_Channel_Id__Model old =
    { channelId = old.channelId
    , channel = old.channel
    , playlists = old.playlists |> Dict.map (\k -> migrate_Api_YoutubeModel_Playlist)
    , latestVideos = old.latestVideos
    , schedules = old.schedules
    , tmpCompetitors = old.tmpCompetitors
    }


migrate_Pages_Channel_Id__Msg : Evergreen.V40.Pages.Channel.Id_.Msg -> Evergreen.V48.Pages.Channel.Id_.Msg
migrate_Pages_Channel_Id__Msg old =
    case old of
        Evergreen.V40.Pages.Channel.Id_.GotChannelAndPlaylists p0 p1 p2 p3 ->
            Evergreen.V48.Pages.Channel.Id_.GotChannelAndPlaylists (p0 |> migrate_Api_YoutubeModel_Channel)
                (p1 |> Dict.map (\k -> migrate_Api_YoutubeModel_Playlist))
                p2
                p3

        Evergreen.V40.Pages.Channel.Id_.GetPlaylists ->
            Evergreen.V48.Pages.Channel.Id_.GetPlaylists

        Evergreen.V40.Pages.Channel.Id_.Schedule_UpdateSchedule p0 ->
            Evergreen.V48.Pages.Channel.Id_.Schedule_UpdateSchedule (p0 |> migrate_Api_YoutubeModel_Schedule)

        Evergreen.V40.Pages.Channel.Id_.MonitorPlaylist p0 p1 ->
            Evergreen.V48.Pages.Channel.Id_.MonitorPlaylist (p0 |> migrate_Api_YoutubeModel_Playlist) p1

        Evergreen.V40.Pages.Channel.Id_.Competitors p0 p1 ->
            Evergreen.V48.Pages.Channel.Id_.Competitors (p0 |> migrate_Api_YoutubeModel_Playlist) p1


migrate_Pages_End_Model : Evergreen.V40.Pages.End.Model -> Evergreen.V48.Pages.End.Model
migrate_Pages_End_Model old =
    old


migrate_Pages_End_Msg : Evergreen.V40.Pages.End.Msg -> Evergreen.V48.Pages.End.Msg
migrate_Pages_End_Msg old =
    case old of
        Evergreen.V40.Pages.End.ReplaceMe ->
            Evergreen.V48.Pages.End.ReplaceMe


migrate_Pages_Example_Model : Evergreen.V40.Pages.Example.Model -> Evergreen.V48.Pages.Example.Model
migrate_Pages_Example_Model old =
    old


migrate_Pages_Example_Msg : Evergreen.V40.Pages.Example.Msg -> Evergreen.V48.Pages.Example.Msg
migrate_Pages_Example_Msg old =
    case old of
        Evergreen.V40.Pages.Example.GotCredentials p0 ->
            Evergreen.V48.Pages.Example.GotCredentials p0

        Evergreen.V40.Pages.Example.GetChannels p0 ->
            Evergreen.V48.Pages.Example.GetChannels p0

        Evergreen.V40.Pages.Example.Yeet p0 ->
            Evergreen.V48.Pages.Example.Yeet p0

        Evergreen.V40.Pages.Example.Tick p0 ->
            Evergreen.V48.Pages.Example.Tick p0


migrate_Pages_Ga_Email__Model : Evergreen.V40.Pages.Ga.Email_.Model -> Evergreen.V48.Pages.Ga.Email_.Model
migrate_Pages_Ga_Email__Model old =
    old


migrate_Pages_Ga_Email__Msg : Evergreen.V40.Pages.Ga.Email_.Msg -> Evergreen.V48.Pages.Ga.Email_.Msg
migrate_Pages_Ga_Email__Msg old =
    case old of
        Evergreen.V40.Pages.Ga.Email_.GotChannels p0 ->
            Evergreen.V48.Pages.Ga.Email_.GotChannels p0

        Evergreen.V40.Pages.Ga.Email_.GetChannels ->
            Evergreen.V48.Pages.Ga.Email_.GetChannels


migrate_Pages_Home__Model : Evergreen.V40.Pages.Home_.Model -> Evergreen.V48.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V40.Pages.Home_.Msg -> Evergreen.V48.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V40.Pages.Home_.Noop ->
            Evergreen.V48.Pages.Home_.Noop


migrate_Pages_Log_Model : Evergreen.V40.Pages.Log.Model -> Evergreen.V48.Pages.Log.Model
migrate_Pages_Log_Model old =
    { logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    , logIndex = old.logIndex
    }


migrate_Pages_Log_Msg : Evergreen.V40.Pages.Log.Msg -> Evergreen.V48.Pages.Log.Msg
migrate_Pages_Log_Msg old =
    case old of
        Evergreen.V40.Pages.Log.GotLogs p0 p1 ->
            Evergreen.V48.Pages.Log.GotLogs p0 (p1 |> List.map migrate_Api_Logging_LogEntry)

        Evergreen.V40.Pages.Log.GetLogPage p0 p1 ->
            Evergreen.V48.Pages.Log.GetLogPage p0 p1

        Evergreen.V40.Pages.Log.YeetLogs ->
            Evergreen.V48.Pages.Log.YeetLogs

        Evergreen.V40.Pages.Log.YeetVideos ->
            Evergreen.V48.Pages.Log.YeetVideos

        Evergreen.V40.Pages.Log.Batch_RefreshAccessTokens ->
            Evergreen.V48.Pages.Log.Batch_RefreshAccessTokens

        Evergreen.V40.Pages.Log.Batch_RefreshAllChannels ->
            Evergreen.V48.Pages.Log.Batch_RefreshAllChannels

        Evergreen.V40.Pages.Log.Batch_RefreshAllPlaylists ->
            Evergreen.V48.Pages.Log.Batch_RefreshAllPlaylists

        Evergreen.V40.Pages.Log.Batch_RefreshAllVideosFromPlaylists ->
            Evergreen.V48.Pages.Log.Batch_RefreshAllVideosFromPlaylists

        Evergreen.V40.Pages.Log.Batch_GetLiveVideoStreamData ->
            Evergreen.V48.Pages.Log.Batch_GetLiveVideoStreamData

        Evergreen.V40.Pages.Log.Batch_GetVideoStats ->
            Evergreen.V48.Pages.Log.Batch_GetVideoStats

        Evergreen.V40.Pages.Log.Batch_GetVideoDailyReports ->
            Evergreen.V48.Pages.Log.Batch_GetVideoDailyReports

        Evergreen.V40.Pages.Log.Batch_GetChatMessages ->
            Evergreen.V48.Pages.Log.Batch_GetChatMessages

        Evergreen.V40.Pages.Log.Batch_GetVideoStatisticsAtTime ->
            Evergreen.V48.Pages.Log.Batch_GetVideoStatisticsAtTime

        Evergreen.V40.Pages.Log.Batch_GetCompetitorVideos ->
            Evergreen.V48.Pages.Log.Batch_GetCompetitorVideos


migrate_Pages_Login_Field : Evergreen.V40.Pages.Login.Field -> Evergreen.V48.Pages.Login.Field
migrate_Pages_Login_Field old =
    case old of
        Evergreen.V40.Pages.Login.Email ->
            Evergreen.V48.Pages.Login.Email

        Evergreen.V40.Pages.Login.Password ->
            Evergreen.V48.Pages.Login.Password


migrate_Pages_Login_Model : Evergreen.V40.Pages.Login.Model -> Evergreen.V48.Pages.Login.Model
migrate_Pages_Login_Model old =
    old


migrate_Pages_Login_Msg : Evergreen.V40.Pages.Login.Msg -> Evergreen.V48.Pages.Login.Msg
migrate_Pages_Login_Msg old =
    case old of
        Evergreen.V40.Pages.Login.Updated p0 p1 ->
            Evergreen.V48.Pages.Login.Updated (p0 |> migrate_Pages_Login_Field) p1

        Evergreen.V40.Pages.Login.ToggledShowPassword ->
            Evergreen.V48.Pages.Login.ToggledShowPassword

        Evergreen.V40.Pages.Login.ClickedSubmit ->
            Evergreen.V48.Pages.Login.ClickedSubmit

        Evergreen.V40.Pages.Login.GotUser p0 ->
            Evergreen.V48.Pages.Login.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Playlist_Id__Model : Evergreen.V40.Pages.Playlist.Id_.Model -> Evergreen.V48.Pages.Playlist.Id_.Model
migrate_Pages_Playlist_Id__Model old =
    { playlistId = old.playlistId
    , playlistTitle = old.playlistTitle
    , videos = old.videos |> Dict.map (\k -> migrate_Api_YoutubeModel_Video)
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , videoChannels = old.videoChannels
    , playlists = old.playlists |> Dict.map (\k -> migrate_Api_YoutubeModel_Playlist)
    , videoStats = old.videoStats
    , competitorVideos = Dict.empty
    , currentIntTime = old.currentIntTime
    }


migrate_Pages_Playlist_Id__Msg : Evergreen.V40.Pages.Playlist.Id_.Msg -> Evergreen.V48.Pages.Playlist.Id_.Msg
migrate_Pages_Playlist_Id__Msg old =
    case old of
        Evergreen.V40.Pages.Playlist.Id_.GotVideos p0 p1 p2 p3 p4 p5 p6 ->
            Evergreen.V48.Pages.Playlist.Id_.GotVideos Dict.empty
                Dict.empty
                p2
                p3
                p4
                p5
                Dict.empty

        Evergreen.V40.Pages.Playlist.Id_.GetVideos ->
            Evergreen.V48.Pages.Playlist.Id_.GetVideos

        Evergreen.V40.Pages.Playlist.Id_.Tick p0 ->
            Evergreen.V48.Pages.Playlist.Id_.Tick p0


migrate_Pages_Register_Field : Evergreen.V40.Pages.Register.Field -> Evergreen.V48.Pages.Register.Field
migrate_Pages_Register_Field old =
    case old of
        Evergreen.V40.Pages.Register.Email ->
            Evergreen.V48.Pages.Register.Email

        Evergreen.V40.Pages.Register.Password ->
            Evergreen.V48.Pages.Register.Password


migrate_Pages_Register_Model : Evergreen.V40.Pages.Register.Model -> Evergreen.V48.Pages.Register.Model
migrate_Pages_Register_Model old =
    old


migrate_Pages_Register_Msg : Evergreen.V40.Pages.Register.Msg -> Evergreen.V48.Pages.Register.Msg
migrate_Pages_Register_Msg old =
    case old of
        Evergreen.V40.Pages.Register.Updated p0 p1 ->
            Evergreen.V48.Pages.Register.Updated (p0 |> migrate_Pages_Register_Field) p1

        Evergreen.V40.Pages.Register.ToggledShowPassword ->
            Evergreen.V48.Pages.Register.ToggledShowPassword

        Evergreen.V40.Pages.Register.ClickedSubmit ->
            Evergreen.V48.Pages.Register.ClickedSubmit

        Evergreen.V40.Pages.Register.GotUser p0 ->
            Evergreen.V48.Pages.Register.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Video_Id__Model : Evergreen.V40.Pages.Video.Id_.Model -> Evergreen.V48.Pages.Video.Id_.Model
migrate_Pages_Video_Id__Model old =
    { channelTitle = old.channelTitle
    , playlistTitle = old.playlistTitle
    , video = old.video |> Maybe.map migrate_Api_YoutubeModel_Video
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , videoStatisticsAtTime = old.videoStatisticsAtTime
    }


migrate_Pages_Video_Id__Msg : Evergreen.V40.Pages.Video.Id_.Msg -> Evergreen.V48.Pages.Video.Id_.Msg
migrate_Pages_Video_Id__Msg old =
    case old of
        Evergreen.V40.Pages.Video.Id_.ReplaceMe ->
            Evergreen.V48.Pages.Video.Id_.ReplaceMe

        Evergreen.V40.Pages.Video.Id_.GotVideoDetails p0 ->
            Evergreen.V48.Pages.Video.Id_.GotVideoDetails (p0 |> migrate_Pages_Video_Id__Model)


migrate_Shared_Model : Evergreen.V40.Shared.Model -> Evergreen.V48.Shared.Model
migrate_Shared_Model old =
    { viewWidth = old.viewWidth
    , user = old.user |> Maybe.map migrate_Api_User_User
    , toastMessage = old.toastMessage
    }


migrate_Shared_Msg : Evergreen.V40.Shared.Msg -> Evergreen.V48.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V40.Shared.GotViewWidth p0 ->
            Evergreen.V48.Shared.GotViewWidth p0

        Evergreen.V40.Shared.Noop ->
            Evergreen.V48.Shared.Noop

        Evergreen.V40.Shared.SignInUser p0 ->
            Evergreen.V48.Shared.SignInUser (p0 |> migrate_Api_User_User)

        Evergreen.V40.Shared.SignOutUser ->
            Evergreen.V48.Shared.SignOutUser

        Evergreen.V40.Shared.ShowToastMessage p0 ->
            Evergreen.V48.Shared.ShowToastMessage p0

        Evergreen.V40.Shared.HideToastMessage p0 ->
            Evergreen.V48.Shared.HideToastMessage p0


migrate_Types_FrontendMsg : Evergreen.V40.Types.FrontendMsg -> Evergreen.V48.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V40.Types.ChangedUrl p0 ->
            Evergreen.V48.Types.ChangedUrl p0

        Evergreen.V40.Types.ClickedLink p0 ->
            Evergreen.V48.Types.ClickedLink p0

        Evergreen.V40.Types.Shared p0 ->
            Evergreen.V48.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V40.Types.Page p0 ->
            Evergreen.V48.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V40.Types.Noop ->
            Evergreen.V48.Types.Noop


migrate_Types_ToFrontend : Evergreen.V40.Types.ToFrontend -> Evergreen.V48.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V40.Types.PageMsg p0 ->
            Evergreen.V48.Types.PageMsg (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V40.Types.SharedMsg p0 ->
            Evergreen.V48.Types.SharedMsg (p0 |> migrate_Shared_Msg)

        Evergreen.V40.Types.NoOpToFrontend ->
            Evergreen.V48.Types.NoOpToFrontend
