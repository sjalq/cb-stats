module Evergreen.Migrate.V66 exposing (..)

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
import Evergreen.V54.Api.Data
import Evergreen.V54.Api.Logging
import Evergreen.V54.Api.User
import Evergreen.V54.Api.YoutubeModel
import Evergreen.V54.Bridge
import Evergreen.V54.Gen.Model
import Evergreen.V54.Gen.Msg
import Evergreen.V54.Gen.Pages
import Evergreen.V54.Gen.Params.Channel.Id_
import Evergreen.V54.Gen.Params.Ga.Email_
import Evergreen.V54.Gen.Params.Playlist.Id_
import Evergreen.V54.Gen.Params.Video.Id_
import Evergreen.V54.Pages.Admin
import Evergreen.V54.Pages.Channel.Id_
import Evergreen.V54.Pages.End
import Evergreen.V54.Pages.Example
import Evergreen.V54.Pages.Ga.Email_
import Evergreen.V54.Pages.Home_
import Evergreen.V54.Pages.Log
import Evergreen.V54.Pages.Login
import Evergreen.V54.Pages.Playlist.Id_
import Evergreen.V54.Pages.Register
import Evergreen.V54.Pages.Video.Id_
import Evergreen.V54.Shared
import Evergreen.V54.Types
import Evergreen.V66.Api.Data
import Evergreen.V66.Api.Logging
import Evergreen.V66.Api.User
import Evergreen.V66.Api.YoutubeModel
import Evergreen.V66.Bridge
import Evergreen.V66.Gen.Model
import Evergreen.V66.Gen.Msg
import Evergreen.V66.Gen.Pages
import Evergreen.V66.Gen.Params.Channel.Id_
import Evergreen.V66.Gen.Params.Ga.Email_
import Evergreen.V66.Gen.Params.Playlist.Id_
import Evergreen.V66.Gen.Params.Video.Id_
import Evergreen.V66.Pages.Admin
import Evergreen.V66.Pages.Channel.Id_
import Evergreen.V66.Pages.End
import Evergreen.V66.Pages.Example
import Evergreen.V66.Pages.Ga.Email_
import Evergreen.V66.Pages.Home_
import Evergreen.V66.Pages.Log
import Evergreen.V66.Pages.Login
import Evergreen.V66.Pages.Playlist.Id_
import Evergreen.V66.Pages.Register
import Evergreen.V66.Pages.Video.Id_
import Evergreen.V66.Shared
import Evergreen.V66.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe


frontendModel : Evergreen.V54.Types.FrontendModel -> ModelMigration Evergreen.V66.Types.FrontendModel Evergreen.V66.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V54.Types.BackendModel -> ModelMigration Evergreen.V66.Types.BackendModel Evergreen.V66.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V54.Types.FrontendMsg -> MsgMigration Evergreen.V66.Types.FrontendMsg Evergreen.V66.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V54.Types.ToBackend -> MsgMigration Evergreen.V66.Types.ToBackend Evergreen.V66.Types.BackendMsg
toBackend old =
    MsgMigrated ( migrate_Types_ToBackend old, Cmd.none )


backendMsg : Evergreen.V54.Types.BackendMsg -> MsgMigration Evergreen.V66.Types.BackendMsg Evergreen.V66.Types.BackendMsg
backendMsg old =
    MsgUnchanged


toFrontend : Evergreen.V54.Types.ToFrontend -> MsgMigration Evergreen.V66.Types.ToFrontend Evergreen.V66.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V54.Types.BackendModel -> Evergreen.V66.Types.BackendModel
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
    , channelHandleMap = old.channelHandleMap
    , apiCallCount = old.apiCallCount
    }


migrate_Types_FrontendModel : Evergreen.V54.Types.FrontendModel -> Evergreen.V66.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_Types_ToBackend : Evergreen.V54.Types.ToBackend -> Evergreen.V66.Types.ToBackend
migrate_Types_ToBackend old =
    old |> migrate_Bridge_ToBackend


migrate_Api_Data_Data : (value_old -> value_new) -> Evergreen.V54.Api.Data.Data value_old -> Evergreen.V66.Api.Data.Data value_new
migrate_Api_Data_Data migrate_value old =
    case old of
        Evergreen.V54.Api.Data.NotAsked ->
            Evergreen.V66.Api.Data.NotAsked

        Evergreen.V54.Api.Data.Loading ->
            Evergreen.V66.Api.Data.Loading

        Evergreen.V54.Api.Data.Failure p0 ->
            Evergreen.V66.Api.Data.Failure p0

        Evergreen.V54.Api.Data.Success p0 ->
            Evergreen.V66.Api.Data.Success (p0 |> migrate_value)


migrate_Api_Logging_LogEntry : Evergreen.V54.Api.Logging.LogEntry -> Evergreen.V66.Api.Logging.LogEntry
migrate_Api_Logging_LogEntry old =
    { message = old.message
    , timestamp = old.timestamp
    , logLevel = old.logLevel |> migrate_Api_Logging_LogLevel
    }


migrate_Api_Logging_LogLevel : Evergreen.V54.Api.Logging.LogLevel -> Evergreen.V66.Api.Logging.LogLevel
migrate_Api_Logging_LogLevel old =
    case old of
        Evergreen.V54.Api.Logging.Error ->
            Evergreen.V66.Api.Logging.Error

        Evergreen.V54.Api.Logging.Info ->
            Evergreen.V66.Api.Logging.Info

        Evergreen.V54.Api.Logging.Alert ->
            Evergreen.V66.Api.Logging.Alert


migrate_Api_User_Role : Evergreen.V54.Api.User.Role -> Evergreen.V66.Api.User.Role
migrate_Api_User_Role old =
    case old of
        Evergreen.V54.Api.User.Basic ->
            Evergreen.V66.Api.User.Basic

        Evergreen.V54.Api.User.Editor ->
            Evergreen.V66.Api.User.Editor

        Evergreen.V54.Api.User.Admin ->
            Evergreen.V66.Api.User.Admin


migrate_Api_User_User : Evergreen.V54.Api.User.User -> Evergreen.V66.Api.User.User
migrate_Api_User_User old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    }


migrate_Api_User_UserFull : Evergreen.V54.Api.User.UserFull -> Evergreen.V66.Api.User.UserFull
migrate_Api_User_UserFull old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    , passwordHash = old.passwordHash
    , salt = old.salt
    }


migrate_Api_YoutubeModel_Channel : Evergreen.V54.Api.YoutubeModel.Channel -> Evergreen.V66.Api.YoutubeModel.Channel
migrate_Api_YoutubeModel_Channel old =
    old


migrate_Api_YoutubeModel_DaysOfWeek : Evergreen.V54.Api.YoutubeModel.DaysOfWeek -> Evergreen.V66.Api.YoutubeModel.DaysOfWeek
migrate_Api_YoutubeModel_DaysOfWeek old =
    old


migrate_Api_YoutubeModel_LiveStatus : Evergreen.V54.Api.YoutubeModel.LiveStatus -> Evergreen.V66.Api.YoutubeModel.LiveStatus
migrate_Api_YoutubeModel_LiveStatus old =
    case old of
        Evergreen.V54.Api.YoutubeModel.Unknown ->
            Evergreen.V66.Api.YoutubeModel.Unknown

        Evergreen.V54.Api.YoutubeModel.Uploaded ->
            Evergreen.V66.Api.YoutubeModel.Uploaded

        Evergreen.V54.Api.YoutubeModel.Scheduled p0 ->
            Evergreen.V66.Api.YoutubeModel.Scheduled p0

        Evergreen.V54.Api.YoutubeModel.Expired ->
            Evergreen.V66.Api.YoutubeModel.Expired

        Evergreen.V54.Api.YoutubeModel.Old ->
            Evergreen.V66.Api.YoutubeModel.Old

        Evergreen.V54.Api.YoutubeModel.Live ->
            Evergreen.V66.Api.YoutubeModel.Live

        Evergreen.V54.Api.YoutubeModel.Ended p0 ->
            Evergreen.V66.Api.YoutubeModel.Ended p0

        Evergreen.V54.Api.YoutubeModel.Impossibru ->
            Evergreen.V66.Api.YoutubeModel.Impossibru


migrate_Api_YoutubeModel_Playlist : Evergreen.V54.Api.YoutubeModel.Playlist -> Evergreen.V66.Api.YoutubeModel.Playlist
migrate_Api_YoutubeModel_Playlist old =
    old


migrate_Api_YoutubeModel_Schedule : Evergreen.V54.Api.YoutubeModel.Schedule -> Evergreen.V66.Api.YoutubeModel.Schedule
migrate_Api_YoutubeModel_Schedule old =
    { playlistId = old.playlistId
    , hour = old.hour
    , minute = old.minute
    , days = old.days |> migrate_Api_YoutubeModel_DaysOfWeek
    }


migrate_Api_YoutubeModel_Video : Evergreen.V54.Api.YoutubeModel.Video -> Evergreen.V66.Api.YoutubeModel.Video
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
    , ctr = Nothing
    , liveViews = Nothing
    }


migrate_Api_YoutubeModel_VideoResults : Evergreen.V54.Api.YoutubeModel.VideoResults -> Evergreen.V66.Api.YoutubeModel.VideoResults
migrate_Api_YoutubeModel_VideoResults old =
    { playlists = old.playlists
    , videos = old.videos |> Dict.map (\k -> migrate_Api_YoutubeModel_Video)
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , videoChannels = old.videoChannels
    , videoStats = old.videoStats
    , competitorVideos = old.competitorVideos |> Dict.map (\k -> Dict.map (\k2 -> migrate_Api_YoutubeModel_Video))
    }


migrate_Bridge_ToBackend : Evergreen.V54.Bridge.ToBackend -> Evergreen.V66.Bridge.ToBackend
migrate_Bridge_ToBackend old =
    case old of
        Evergreen.V54.Bridge.AttemptRegistration p0 ->
            Evergreen.V66.Bridge.AttemptRegistration p0

        Evergreen.V54.Bridge.AttemptSignIn p0 ->
            Evergreen.V66.Bridge.AttemptSignIn p0

        Evergreen.V54.Bridge.AttemptSignOut ->
            Evergreen.V66.Bridge.AttemptSignOut

        Evergreen.V54.Bridge.AttemptGetCredentials ->
            Evergreen.V66.Bridge.AttemptGetCredentials

        Evergreen.V54.Bridge.AttemptGetChannels p0 ->
            Evergreen.V66.Bridge.AttemptGetChannels p0

        Evergreen.V54.Bridge.AttemptGetVideos p0 ->
            Evergreen.V66.Bridge.AttemptGetVideos p0

        Evergreen.V54.Bridge.AttemptYeetCredentials p0 ->
            Evergreen.V66.Bridge.AttemptYeetCredentials p0

        Evergreen.V54.Bridge.FetchChannelsFromYoutube p0 ->
            Evergreen.V66.Bridge.FetchChannelsFromYoutube p0

        Evergreen.V54.Bridge.FetchPlaylistsFromYoutube p0 ->
            Evergreen.V66.Bridge.FetchPlaylistsFromYoutube p0

        Evergreen.V54.Bridge.FetchVideosFromYoutube p0 ->
            Evergreen.V66.Bridge.FetchVideosFromYoutube p0

        Evergreen.V54.Bridge.AttemptGetChannelAndPlaylists p0 ->
            Evergreen.V66.Bridge.AttemptGetChannelAndPlaylists p0

        Evergreen.V54.Bridge.AttemptGetLogs p0 p1 ->
            Evergreen.V66.Bridge.AttemptGetLogs p0 p1

        Evergreen.V54.Bridge.AttemptYeetLogs ->
            Evergreen.V66.Bridge.AttemptYeetLogs

        Evergreen.V54.Bridge.AttemptYeetVideos ->
            Evergreen.V66.Bridge.AttemptYeetVideos

        Evergreen.V54.Bridge.AttemptGetVideoDetails p0 ->
            Evergreen.V66.Bridge.AttemptGetVideoDetails p0

        Evergreen.V54.Bridge.AttemptBatch_RefreshAccessTokens ->
            Evergreen.V66.Bridge.AttemptBatch_RefreshAccessTokens

        Evergreen.V54.Bridge.AttemptBatch_RefreshAllChannels ->
            Evergreen.V66.Bridge.AttemptBatch_RefreshAllChannels

        Evergreen.V54.Bridge.AttemptBatch_RefreshAllPlaylists ->
            Evergreen.V66.Bridge.AttemptBatch_RefreshAllPlaylists

        Evergreen.V54.Bridge.AttemptBatch_RefreshAllVideosFromPlaylists ->
            Evergreen.V66.Bridge.AttemptBatch_RefreshAllVideosFromPlaylists

        Evergreen.V54.Bridge.AttemptBatch_GetLiveVideoStreamData ->
            Evergreen.V66.Bridge.AttemptBatch_GetLiveVideoStreamData

        Evergreen.V54.Bridge.AttemptBatch_GetVideoStats ->
            Evergreen.V66.Bridge.AttemptBatch_GetVideoStats

        Evergreen.V54.Bridge.AttemptBatch_GetVideoDailyReports ->
            Evergreen.V66.Bridge.AttemptBatch_GetVideoDailyReports

        Evergreen.V54.Bridge.AttemptBatch_GetChatMessages ->
            Evergreen.V66.Bridge.AttemptBatch_GetChatMessages

        Evergreen.V54.Bridge.AttemptBatch_GetVideoStatisticsAtTime ->
            Evergreen.V66.Bridge.AttemptBatch_GetVideoStatisticsAtTime

        Evergreen.V54.Bridge.AttemptBatch_GetCompetitorVideos ->
            Evergreen.V66.Bridge.AttemptBatch_GetCompetitorVideos

        Evergreen.V54.Bridge.AttemptBatch_ExportToSheet ->
            Evergreen.V66.Bridge.AttemptBatch_ExportToSheet

        Evergreen.V54.Bridge.AttemptFixData ->
            Evergreen.V66.Bridge.AttemptFixData

        Evergreen.V54.Bridge.UpdateSchedule p0 ->
            Evergreen.V66.Bridge.UpdateSchedule (p0 |> migrate_Api_YoutubeModel_Schedule)

        Evergreen.V54.Bridge.UpdatePlaylist p0 ->
            Evergreen.V66.Bridge.UpdatePlaylist (p0 |> migrate_Api_YoutubeModel_Playlist)

        Evergreen.V54.Bridge.NoOpToBackend ->
            Evergreen.V66.Bridge.NoOpToBackend



migrate_Gen_Model_Model : Evergreen.V54.Gen.Model.Model -> Evergreen.V66.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V54.Gen.Model.Redirecting_ ->
            Evergreen.V66.Gen.Model.Redirecting_

        Evergreen.V54.Gen.Model.Admin p0 p1 ->
            Evergreen.V66.Gen.Model.Admin p0 (p1 |> migrate_Pages_Admin_Model)

        Evergreen.V54.Gen.Model.End p0 p1 ->
            Evergreen.V66.Gen.Model.End p0 (p1 |> migrate_Pages_End_Model)

        Evergreen.V54.Gen.Model.Example p0 p1 ->
            Evergreen.V66.Gen.Model.Example p0 (p1 |> migrate_Pages_Example_Model)

        Evergreen.V54.Gen.Model.Home_ p0 p1 ->
            Evergreen.V66.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V54.Gen.Model.Log p0 p1 ->
            Evergreen.V66.Gen.Model.Log p0 (p1 |> migrate_Pages_Log_Model)

        Evergreen.V54.Gen.Model.Login p0 p1 ->
            Evergreen.V66.Gen.Model.Login p0 (p1 |> migrate_Pages_Login_Model)

        Evergreen.V54.Gen.Model.NotFound p0 ->
            Evergreen.V66.Gen.Model.NotFound p0

        Evergreen.V54.Gen.Model.Register p0 p1 ->
            Evergreen.V66.Gen.Model.Register p0 (p1 |> migrate_Pages_Register_Model)

        Evergreen.V54.Gen.Model.Channel__Id_ p0 p1 ->
            Evergreen.V66.Gen.Model.Channel__Id_ (p0 |> migrate_Gen_Params_Channel_Id__Params)
                (p1 |> migrate_Pages_Channel_Id__Model)

        Evergreen.V54.Gen.Model.Ga__Email_ p0 p1 ->
            Evergreen.V66.Gen.Model.Ga__Email_ (p0 |> migrate_Gen_Params_Ga_Email__Params)
                (p1 |> migrate_Pages_Ga_Email__Model)

        Evergreen.V54.Gen.Model.Playlist__Id_ p0 p1 ->
            Evergreen.V66.Gen.Model.Playlist__Id_ (p0 |> migrate_Gen_Params_Playlist_Id__Params)
                (p1 |> migrate_Pages_Playlist_Id__Model)

        Evergreen.V54.Gen.Model.Video__Id_ p0 p1 ->
            Evergreen.V66.Gen.Model.Video__Id_ (p0 |> migrate_Gen_Params_Video_Id__Params)
                (p1 |> migrate_Pages_Video_Id__Model)


migrate_Gen_Msg_Msg : Evergreen.V54.Gen.Msg.Msg -> Evergreen.V66.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V54.Gen.Msg.Admin p0 ->
            Evergreen.V66.Gen.Msg.Admin (p0 |> migrate_Pages_Admin_Msg)

        Evergreen.V54.Gen.Msg.End p0 ->
            Evergreen.V66.Gen.Msg.End (p0 |> migrate_Pages_End_Msg)

        Evergreen.V54.Gen.Msg.Example p0 ->
            Evergreen.V66.Gen.Msg.Example (p0 |> migrate_Pages_Example_Msg)

        Evergreen.V54.Gen.Msg.Home_ p0 ->
            Evergreen.V66.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V54.Gen.Msg.Log p0 ->
            Evergreen.V66.Gen.Msg.Log (p0 |> migrate_Pages_Log_Msg)

        Evergreen.V54.Gen.Msg.Login p0 ->
            Evergreen.V66.Gen.Msg.Login (p0 |> migrate_Pages_Login_Msg)

        Evergreen.V54.Gen.Msg.Register p0 ->
            Evergreen.V66.Gen.Msg.Register (p0 |> migrate_Pages_Register_Msg)

        Evergreen.V54.Gen.Msg.Channel__Id_ p0 ->
            Evergreen.V66.Gen.Msg.Channel__Id_ (p0 |> migrate_Pages_Channel_Id__Msg)

        Evergreen.V54.Gen.Msg.Ga__Email_ p0 ->
            Evergreen.V66.Gen.Msg.Ga__Email_ (p0 |> migrate_Pages_Ga_Email__Msg)

        Evergreen.V54.Gen.Msg.Playlist__Id_ p0 ->
            Evergreen.V66.Gen.Msg.Playlist__Id_ (p0 |> migrate_Pages_Playlist_Id__Msg)

        Evergreen.V54.Gen.Msg.Video__Id_ p0 ->
            Evergreen.V66.Gen.Msg.Video__Id_ (p0 |> migrate_Pages_Video_Id__Msg)


migrate_Gen_Pages_Model : Evergreen.V54.Gen.Pages.Model -> Evergreen.V66.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V54.Gen.Pages.Msg -> Evergreen.V66.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Gen_Params_Channel_Id__Params : Evergreen.V54.Gen.Params.Channel.Id_.Params -> Evergreen.V66.Gen.Params.Channel.Id_.Params
migrate_Gen_Params_Channel_Id__Params old =
    old


migrate_Gen_Params_Ga_Email__Params : Evergreen.V54.Gen.Params.Ga.Email_.Params -> Evergreen.V66.Gen.Params.Ga.Email_.Params
migrate_Gen_Params_Ga_Email__Params old =
    old


migrate_Gen_Params_Playlist_Id__Params : Evergreen.V54.Gen.Params.Playlist.Id_.Params -> Evergreen.V66.Gen.Params.Playlist.Id_.Params
migrate_Gen_Params_Playlist_Id__Params old =
    old


migrate_Gen_Params_Video_Id__Params : Evergreen.V54.Gen.Params.Video.Id_.Params -> Evergreen.V66.Gen.Params.Video.Id_.Params
migrate_Gen_Params_Video_Id__Params old =
    old


migrate_Pages_Admin_Model : Evergreen.V54.Pages.Admin.Model -> Evergreen.V66.Pages.Admin.Model
migrate_Pages_Admin_Model old =
    old


migrate_Pages_Admin_Msg : Evergreen.V54.Pages.Admin.Msg -> Evergreen.V66.Pages.Admin.Msg
migrate_Pages_Admin_Msg old =
    case old of
        Evergreen.V54.Pages.Admin.ReplaceMe ->
            Evergreen.V66.Pages.Admin.ReplaceMe


migrate_Pages_Channel_Id__Model : Evergreen.V54.Pages.Channel.Id_.Model -> Evergreen.V66.Pages.Channel.Id_.Model
migrate_Pages_Channel_Id__Model old =
    old


migrate_Pages_Channel_Id__Msg : Evergreen.V54.Pages.Channel.Id_.Msg -> Evergreen.V66.Pages.Channel.Id_.Msg
migrate_Pages_Channel_Id__Msg old =
    case old of
        Evergreen.V54.Pages.Channel.Id_.GotChannelAndPlaylists p0 p1 p2 p3 ->
            Evergreen.V66.Pages.Channel.Id_.GotChannelAndPlaylists (p0 |> migrate_Api_YoutubeModel_Channel) p1 p2 p3

        Evergreen.V54.Pages.Channel.Id_.GetPlaylists ->
            Evergreen.V66.Pages.Channel.Id_.GetPlaylists

        Evergreen.V54.Pages.Channel.Id_.Schedule_UpdateSchedule p0 ->
            Evergreen.V66.Pages.Channel.Id_.Schedule_UpdateSchedule (p0 |> migrate_Api_YoutubeModel_Schedule)

        Evergreen.V54.Pages.Channel.Id_.MonitorPlaylist p0 p1 ->
            Evergreen.V66.Pages.Channel.Id_.MonitorPlaylist (p0 |> migrate_Api_YoutubeModel_Playlist) p1

        Evergreen.V54.Pages.Channel.Id_.Competitors p0 p1 ->
            Evergreen.V66.Pages.Channel.Id_.Competitors (p0 |> migrate_Api_YoutubeModel_Playlist) p1


migrate_Pages_End_Model : Evergreen.V54.Pages.End.Model -> Evergreen.V66.Pages.End.Model
migrate_Pages_End_Model old =
    old


migrate_Pages_End_Msg : Evergreen.V54.Pages.End.Msg -> Evergreen.V66.Pages.End.Msg
migrate_Pages_End_Msg old =
    case old of
        Evergreen.V54.Pages.End.ReplaceMe ->
            Evergreen.V66.Pages.End.ReplaceMe


migrate_Pages_Example_Model : Evergreen.V54.Pages.Example.Model -> Evergreen.V66.Pages.Example.Model
migrate_Pages_Example_Model old =
    old


migrate_Pages_Example_Msg : Evergreen.V54.Pages.Example.Msg -> Evergreen.V66.Pages.Example.Msg
migrate_Pages_Example_Msg old =
    case old of
        Evergreen.V54.Pages.Example.GotCredentials p0 ->
            Evergreen.V66.Pages.Example.GotCredentials p0

        Evergreen.V54.Pages.Example.GetChannels p0 ->
            Evergreen.V66.Pages.Example.GetChannels p0

        Evergreen.V54.Pages.Example.Yeet p0 ->
            Evergreen.V66.Pages.Example.Yeet p0

        Evergreen.V54.Pages.Example.Tick p0 ->
            Evergreen.V66.Pages.Example.Tick p0


migrate_Pages_Ga_Email__Model : Evergreen.V54.Pages.Ga.Email_.Model -> Evergreen.V66.Pages.Ga.Email_.Model
migrate_Pages_Ga_Email__Model old =
    old


migrate_Pages_Ga_Email__Msg : Evergreen.V54.Pages.Ga.Email_.Msg -> Evergreen.V66.Pages.Ga.Email_.Msg
migrate_Pages_Ga_Email__Msg old =
    case old of
        Evergreen.V54.Pages.Ga.Email_.GotChannels p0 ->
            Evergreen.V66.Pages.Ga.Email_.GotChannels p0

        Evergreen.V54.Pages.Ga.Email_.GetChannels ->
            Evergreen.V66.Pages.Ga.Email_.GetChannels


migrate_Pages_Home__Model : Evergreen.V54.Pages.Home_.Model -> Evergreen.V66.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V54.Pages.Home_.Msg -> Evergreen.V66.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V54.Pages.Home_.Noop ->
            Evergreen.V66.Pages.Home_.Noop


migrate_Pages_Log_Model : Evergreen.V54.Pages.Log.Model -> Evergreen.V66.Pages.Log.Model
migrate_Pages_Log_Model old =
    { logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    , logIndex = old.logIndex
    }


migrate_Pages_Log_Msg : Evergreen.V54.Pages.Log.Msg -> Evergreen.V66.Pages.Log.Msg
migrate_Pages_Log_Msg old =
    case old of
        Evergreen.V54.Pages.Log.GotLogs p0 p1 ->
            Evergreen.V66.Pages.Log.GotLogs p0 (p1 |> List.map migrate_Api_Logging_LogEntry)

        Evergreen.V54.Pages.Log.GetLogPage p0 p1 ->
            Evergreen.V66.Pages.Log.GetLogPage p0 p1

        Evergreen.V54.Pages.Log.YeetLogs ->
            Evergreen.V66.Pages.Log.YeetLogs

        Evergreen.V54.Pages.Log.YeetVideos ->
            Evergreen.V66.Pages.Log.YeetVideos

        Evergreen.V54.Pages.Log.Batch_RefreshAccessTokens ->
            Evergreen.V66.Pages.Log.Batch_RefreshAccessTokens

        Evergreen.V54.Pages.Log.Batch_RefreshAllChannels ->
            Evergreen.V66.Pages.Log.Batch_RefreshAllChannels

        Evergreen.V54.Pages.Log.Batch_RefreshAllPlaylists ->
            Evergreen.V66.Pages.Log.Batch_RefreshAllPlaylists

        Evergreen.V54.Pages.Log.Batch_RefreshAllVideosFromPlaylists ->
            Evergreen.V66.Pages.Log.Batch_RefreshAllVideosFromPlaylists

        Evergreen.V54.Pages.Log.Batch_GetLiveVideoStreamData ->
            Evergreen.V66.Pages.Log.Batch_GetLiveVideoStreamData

        Evergreen.V54.Pages.Log.Batch_GetVideoStats ->
            Evergreen.V66.Pages.Log.Batch_GetVideoStats

        Evergreen.V54.Pages.Log.Batch_GetVideoDailyReports ->
            Evergreen.V66.Pages.Log.Batch_GetVideoDailyReports

        Evergreen.V54.Pages.Log.Batch_GetChatMessages ->
            Evergreen.V66.Pages.Log.Batch_GetChatMessages

        Evergreen.V54.Pages.Log.Batch_GetVideoStatisticsAtTime ->
            Evergreen.V66.Pages.Log.Batch_GetVideoStatisticsAtTime

        Evergreen.V54.Pages.Log.Batch_GetCompetitorVideos ->
            Evergreen.V66.Pages.Log.Batch_GetCompetitorVideos

        Evergreen.V54.Pages.Log.Batch_ExportToSheet ->
            Evergreen.V66.Pages.Log.Batch_ExportToSheet

        Evergreen.V54.Pages.Log.FixData ->
            Evergreen.V66.Pages.Log.FixData


migrate_Pages_Login_Field : Evergreen.V54.Pages.Login.Field -> Evergreen.V66.Pages.Login.Field
migrate_Pages_Login_Field old =
    case old of
        Evergreen.V54.Pages.Login.Email ->
            Evergreen.V66.Pages.Login.Email

        Evergreen.V54.Pages.Login.Password ->
            Evergreen.V66.Pages.Login.Password


migrate_Pages_Login_Model : Evergreen.V54.Pages.Login.Model -> Evergreen.V66.Pages.Login.Model
migrate_Pages_Login_Model old =
    old


migrate_Pages_Login_Msg : Evergreen.V54.Pages.Login.Msg -> Evergreen.V66.Pages.Login.Msg
migrate_Pages_Login_Msg old =
    case old of
        Evergreen.V54.Pages.Login.Updated p0 p1 ->
            Evergreen.V66.Pages.Login.Updated (p0 |> migrate_Pages_Login_Field) p1

        Evergreen.V54.Pages.Login.ToggledShowPassword ->
            Evergreen.V66.Pages.Login.ToggledShowPassword

        Evergreen.V54.Pages.Login.ClickedSubmit ->
            Evergreen.V66.Pages.Login.ClickedSubmit

        Evergreen.V54.Pages.Login.GotUser p0 ->
            Evergreen.V66.Pages.Login.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Playlist_Id__Model : Evergreen.V54.Pages.Playlist.Id_.Model -> Evergreen.V66.Pages.Playlist.Id_.Model
migrate_Pages_Playlist_Id__Model old =
    { playlistId = old.playlistId
    , playlistTitle = old.playlistTitle
    , videos = old.videos |> Dict.map (\k -> migrate_Api_YoutubeModel_Video)
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , videoChannels = old.videoChannels
    , playlists = old.playlists
    , videoStats = old.videoStats
    , competitorVideos = old.competitorVideos |> Dict.map (\k -> Dict.map (\k2 -> migrate_Api_YoutubeModel_Video))
    , currentIntTime = old.currentIntTime
    , tmpCtrs = Dict.empty
    , tmpLiveViews = Dict.empty
    }


migrate_Pages_Playlist_Id__Msg : Evergreen.V54.Pages.Playlist.Id_.Msg -> Evergreen.V66.Pages.Playlist.Id_.Msg
migrate_Pages_Playlist_Id__Msg old =
    case old of
        Evergreen.V54.Pages.Playlist.Id_.GotVideos p0 ->
            Evergreen.V66.Pages.Playlist.Id_.GotVideos (p0 |> migrate_Api_YoutubeModel_VideoResults)

        Evergreen.V54.Pages.Playlist.Id_.GetVideos ->
            Evergreen.V66.Pages.Playlist.Id_.GetVideos

        Evergreen.V54.Pages.Playlist.Id_.Tick p0 ->
            Evergreen.V66.Pages.Playlist.Id_.Tick p0


migrate_Pages_Register_Field : Evergreen.V54.Pages.Register.Field -> Evergreen.V66.Pages.Register.Field
migrate_Pages_Register_Field old =
    case old of
        Evergreen.V54.Pages.Register.Email ->
            Evergreen.V66.Pages.Register.Email

        Evergreen.V54.Pages.Register.Password ->
            Evergreen.V66.Pages.Register.Password


migrate_Pages_Register_Model : Evergreen.V54.Pages.Register.Model -> Evergreen.V66.Pages.Register.Model
migrate_Pages_Register_Model old =
    old


migrate_Pages_Register_Msg : Evergreen.V54.Pages.Register.Msg -> Evergreen.V66.Pages.Register.Msg
migrate_Pages_Register_Msg old =
    case old of
        Evergreen.V54.Pages.Register.Updated p0 p1 ->
            Evergreen.V66.Pages.Register.Updated (p0 |> migrate_Pages_Register_Field) p1

        Evergreen.V54.Pages.Register.ToggledShowPassword ->
            Evergreen.V66.Pages.Register.ToggledShowPassword

        Evergreen.V54.Pages.Register.ClickedSubmit ->
            Evergreen.V66.Pages.Register.ClickedSubmit

        Evergreen.V54.Pages.Register.GotUser p0 ->
            Evergreen.V66.Pages.Register.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Video_Id__Model : Evergreen.V54.Pages.Video.Id_.Model -> Evergreen.V66.Pages.Video.Id_.Model
migrate_Pages_Video_Id__Model old =
    { channelTitle = old.channelTitle
    , playlistTitle = old.playlistTitle
    , video = old.video |> Maybe.map migrate_Api_YoutubeModel_Video
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , videoStatisticsAtTime = old.videoStatisticsAtTime
    }


migrate_Pages_Video_Id__Msg : Evergreen.V54.Pages.Video.Id_.Msg -> Evergreen.V66.Pages.Video.Id_.Msg
migrate_Pages_Video_Id__Msg old =
    case old of
        Evergreen.V54.Pages.Video.Id_.ReplaceMe ->
            Evergreen.V66.Pages.Video.Id_.ReplaceMe

        Evergreen.V54.Pages.Video.Id_.GotVideoDetails p0 ->
            Evergreen.V66.Pages.Video.Id_.GotVideoDetails (p0 |> migrate_Pages_Video_Id__Model)


migrate_Shared_Model : Evergreen.V54.Shared.Model -> Evergreen.V66.Shared.Model
migrate_Shared_Model old =
    { viewWidth = old.viewWidth
    , user = old.user |> Maybe.map migrate_Api_User_User
    , toastMessage = old.toastMessage
    }


migrate_Shared_Msg : Evergreen.V54.Shared.Msg -> Evergreen.V66.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V54.Shared.GotViewWidth p0 ->
            Evergreen.V66.Shared.GotViewWidth p0

        Evergreen.V54.Shared.Noop ->
            Evergreen.V66.Shared.Noop

        Evergreen.V54.Shared.SignInUser p0 ->
            Evergreen.V66.Shared.SignInUser (p0 |> migrate_Api_User_User)

        Evergreen.V54.Shared.SignOutUser ->
            Evergreen.V66.Shared.SignOutUser

        Evergreen.V54.Shared.ShowToastMessage p0 ->
            Evergreen.V66.Shared.ShowToastMessage p0

        Evergreen.V54.Shared.HideToastMessage p0 ->
            Evergreen.V66.Shared.HideToastMessage p0


migrate_Types_FrontendMsg : Evergreen.V54.Types.FrontendMsg -> Evergreen.V66.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V54.Types.ChangedUrl p0 ->
            Evergreen.V66.Types.ChangedUrl p0

        Evergreen.V54.Types.ClickedLink p0 ->
            Evergreen.V66.Types.ClickedLink p0

        Evergreen.V54.Types.Shared p0 ->
            Evergreen.V66.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V54.Types.Page p0 ->
            Evergreen.V66.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V54.Types.Noop ->
            Evergreen.V66.Types.Noop


migrate_Types_ToFrontend : Evergreen.V54.Types.ToFrontend -> Evergreen.V66.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V54.Types.PageMsg p0 ->
            Evergreen.V66.Types.PageMsg (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V54.Types.SharedMsg p0 ->
            Evergreen.V66.Types.SharedMsg (p0 |> migrate_Shared_Msg)

        Evergreen.V54.Types.NoOpToFrontend ->
            Evergreen.V66.Types.NoOpToFrontend