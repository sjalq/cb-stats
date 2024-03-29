module Evergreen.Migrate.V18 exposing (..)

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
import Evergreen.V16.Api.Data
import Evergreen.V16.Api.Logging
import Evergreen.V16.Api.User
import Evergreen.V16.Api.YoutubeModel
import Evergreen.V16.Gen.Model
import Evergreen.V16.Gen.Msg
import Evergreen.V16.Gen.Pages
import Evergreen.V16.Gen.Params.Channel.Id_
import Evergreen.V16.Gen.Params.Ga.Email_
import Evergreen.V16.Gen.Params.Playlist.Id_
import Evergreen.V16.Json.Auto.PlaylistItems
import Evergreen.V16.Json.Bespoke.VideoDecoder
import Evergreen.V16.Pages.Admin
import Evergreen.V16.Pages.Channel.Id_
import Evergreen.V16.Pages.End
import Evergreen.V16.Pages.Example
import Evergreen.V16.Pages.Ga.Email_
import Evergreen.V16.Pages.Home_
import Evergreen.V16.Pages.Log
import Evergreen.V16.Pages.Login
import Evergreen.V16.Pages.Playlist.Id_
import Evergreen.V16.Pages.Register
import Evergreen.V16.Shared
import Evergreen.V16.Types
import Evergreen.V18.Api.Data
import Evergreen.V18.Api.Logging
import Evergreen.V18.Api.User
import Evergreen.V18.Api.YoutubeModel
import Evergreen.V18.Gen.Model
import Evergreen.V18.Gen.Msg
import Evergreen.V18.Gen.Pages
import Evergreen.V18.Gen.Params.Channel.Id_
import Evergreen.V18.Gen.Params.Ga.Email_
import Evergreen.V18.Gen.Params.Playlist.Id_
import Evergreen.V18.Json.Auto.PlaylistItems
import Evergreen.V18.Json.Bespoke.VideoDecoder
import Evergreen.V18.Pages.Admin
import Evergreen.V18.Pages.Channel.Id_
import Evergreen.V18.Pages.End
import Evergreen.V18.Pages.Example
import Evergreen.V18.Pages.Ga.Email_
import Evergreen.V18.Pages.Home_
import Evergreen.V18.Pages.Log
import Evergreen.V18.Pages.Login
import Evergreen.V18.Pages.Playlist.Id_
import Evergreen.V18.Pages.Register
import Evergreen.V18.Shared
import Evergreen.V18.Types
import Lamdera.Migrations exposing (..)
import List
import Maybe


frontendModel : Evergreen.V16.Types.FrontendModel -> ModelMigration Evergreen.V18.Types.FrontendModel Evergreen.V18.Types.FrontendMsg
frontendModel old =
    ModelMigrated ( migrate_Types_FrontendModel old, Cmd.none )


backendModel : Evergreen.V16.Types.BackendModel -> ModelMigration Evergreen.V18.Types.BackendModel Evergreen.V18.Types.BackendMsg
backendModel old =
    ModelMigrated ( migrate_Types_BackendModel old, Cmd.none )


frontendMsg : Evergreen.V16.Types.FrontendMsg -> MsgMigration Evergreen.V18.Types.FrontendMsg Evergreen.V18.Types.FrontendMsg
frontendMsg old =
    MsgMigrated ( migrate_Types_FrontendMsg old, Cmd.none )


toBackend : Evergreen.V16.Types.ToBackend -> MsgMigration Evergreen.V18.Types.ToBackend Evergreen.V18.Types.BackendMsg
toBackend old =
    MsgUnchanged


backendMsg : Evergreen.V16.Types.BackendMsg -> MsgMigration Evergreen.V18.Types.BackendMsg Evergreen.V18.Types.BackendMsg
backendMsg old =
    MsgMigrated ( migrate_Types_BackendMsg old, Cmd.none )


toFrontend : Evergreen.V16.Types.ToFrontend -> MsgMigration Evergreen.V18.Types.ToFrontend Evergreen.V18.Types.FrontendMsg
toFrontend old =
    MsgMigrated ( migrate_Types_ToFrontend old, Cmd.none )


migrate_Types_BackendModel : Evergreen.V16.Types.BackendModel -> Evergreen.V18.Types.BackendModel
migrate_Types_BackendModel old =
    { users = old.users |> Dict.map (\k -> migrate_Api_User_UserFull)
    , authenticatedSessions = old.authenticatedSessions
    , incrementedInt = old.incrementedInt
    , logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    , clientCredentials = old.clientCredentials
    , channels = old.channels
    , channelAssociations = old.channelAssociations
    , playlists = old.playlists
    , schedules = old.schedules
    , videos = old.videos |> Dict.map (\k -> migrate_Api_YoutubeModel_Video)
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , apiCallCount = old.apiCallCount
    }


migrate_Types_FrontendModel : Evergreen.V16.Types.FrontendModel -> Evergreen.V18.Types.FrontendModel
migrate_Types_FrontendModel old =
    { url = old.url
    , key = old.key
    , shared = old.shared |> migrate_Shared_Model
    , page = old.page |> migrate_Gen_Pages_Model
    }


migrate_Api_Data_Data : (value_old -> value_new) -> Evergreen.V16.Api.Data.Data value_old -> Evergreen.V18.Api.Data.Data value_new
migrate_Api_Data_Data migrate_value old =
    case old of
        Evergreen.V16.Api.Data.NotAsked ->
            Evergreen.V18.Api.Data.NotAsked

        Evergreen.V16.Api.Data.Loading ->
            Evergreen.V18.Api.Data.Loading

        Evergreen.V16.Api.Data.Failure p0 ->
            Evergreen.V18.Api.Data.Failure p0

        Evergreen.V16.Api.Data.Success p0 ->
            Evergreen.V18.Api.Data.Success (p0 |> migrate_value)


migrate_Api_Logging_LogEntry : Evergreen.V16.Api.Logging.LogEntry -> Evergreen.V18.Api.Logging.LogEntry
migrate_Api_Logging_LogEntry old =
    { message = old.message
    , timestamp = old.timestamp
    , logLevel = old.logLevel |> migrate_Api_Logging_LogLevel
    }


migrate_Api_Logging_LogLevel : Evergreen.V16.Api.Logging.LogLevel -> Evergreen.V18.Api.Logging.LogLevel
migrate_Api_Logging_LogLevel old =
    case old of
        Evergreen.V16.Api.Logging.Error ->
            Evergreen.V18.Api.Logging.Error

        Evergreen.V16.Api.Logging.Info ->
            Evergreen.V18.Api.Logging.Info

        Evergreen.V16.Api.Logging.Alert ->
            Evergreen.V18.Api.Logging.Alert


migrate_Api_User_Role : Evergreen.V16.Api.User.Role -> Evergreen.V18.Api.User.Role
migrate_Api_User_Role old =
    case old of
        Evergreen.V16.Api.User.Basic ->
            Evergreen.V18.Api.User.Basic

        Evergreen.V16.Api.User.Editor ->
            Evergreen.V18.Api.User.Editor

        Evergreen.V16.Api.User.Admin ->
            Evergreen.V18.Api.User.Admin


migrate_Api_User_User : Evergreen.V16.Api.User.User -> Evergreen.V18.Api.User.User
migrate_Api_User_User old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    }


migrate_Api_User_UserFull : Evergreen.V16.Api.User.UserFull -> Evergreen.V18.Api.User.UserFull
migrate_Api_User_UserFull old =
    { email = old.email
    , role = old.role |> migrate_Api_User_Role
    , passwordHash = old.passwordHash
    , salt = old.salt
    }


migrate_Api_YoutubeModel_Channel : Evergreen.V16.Api.YoutubeModel.Channel -> Evergreen.V18.Api.YoutubeModel.Channel
migrate_Api_YoutubeModel_Channel old =
    old


migrate_Api_YoutubeModel_DaysOfWeek : Evergreen.V16.Api.YoutubeModel.DaysOfWeek -> Evergreen.V18.Api.YoutubeModel.DaysOfWeek
migrate_Api_YoutubeModel_DaysOfWeek old =
    old


migrate_Api_YoutubeModel_LiveStatus : Evergreen.V16.Api.YoutubeModel.LiveStatus -> Evergreen.V18.Api.YoutubeModel.LiveStatus
migrate_Api_YoutubeModel_LiveStatus old =
    case old of
        Evergreen.V16.Api.YoutubeModel.Unknown ->
            Evergreen.V18.Api.YoutubeModel.Unknown

        Evergreen.V16.Api.YoutubeModel.NeverLive ->
            Evergreen.V18.Api.YoutubeModel.NeverLive

        Evergreen.V16.Api.YoutubeModel.Scheduled p0 ->
            Evergreen.V18.Api.YoutubeModel.Scheduled p0

        Evergreen.V16.Api.YoutubeModel.Expired ->
            Evergreen.V18.Api.YoutubeModel.Expired

        Evergreen.V16.Api.YoutubeModel.Live ->
            Evergreen.V18.Api.YoutubeModel.Live

        Evergreen.V16.Api.YoutubeModel.Ended ->
            Evergreen.V18.Api.YoutubeModel.Ended ""

        Evergreen.V16.Api.YoutubeModel.Impossibru ->
            Evergreen.V18.Api.YoutubeModel.Impossibru


migrate_Api_YoutubeModel_Playlist : Evergreen.V16.Api.YoutubeModel.Playlist -> Evergreen.V18.Api.YoutubeModel.Playlist
migrate_Api_YoutubeModel_Playlist old =
    old


migrate_Api_YoutubeModel_Schedule : Evergreen.V16.Api.YoutubeModel.Schedule -> Evergreen.V18.Api.YoutubeModel.Schedule
migrate_Api_YoutubeModel_Schedule old =
    { playlistId = old.playlistId
    , hour = old.hour
    , minute = old.minute
    , days = old.days |> migrate_Api_YoutubeModel_DaysOfWeek
    }


migrate_Api_YoutubeModel_Video : Evergreen.V16.Api.YoutubeModel.Video -> Evergreen.V18.Api.YoutubeModel.Video
migrate_Api_YoutubeModel_Video old =
    { id = old.id
    , title = old.title
    , description = old.description
    , channelId = old.channelId
    , playlistId = old.playlistId
    , thumbnailUrl = old.thumbnailUrl |> Just
    , publishedAt = old.publishedAt
    , liveChatId = Nothing
    , liveStatus = old.liveStatus |> migrate_Api_YoutubeModel_LiveStatus
    , statsOnConclusion = Nothing
    , statsAfter24Hours = Nothing
    , reportAfter24Hours = Nothing 
    , chatMsgCount = Nothing
    }


migrate_Gen_Model_Model : Evergreen.V16.Gen.Model.Model -> Evergreen.V18.Gen.Model.Model
migrate_Gen_Model_Model old =
    case old of
        Evergreen.V16.Gen.Model.Redirecting_ ->
            Evergreen.V18.Gen.Model.Redirecting_

        Evergreen.V16.Gen.Model.Admin p0 p1 ->
            Evergreen.V18.Gen.Model.Admin p0 (p1 |> migrate_Pages_Admin_Model)

        Evergreen.V16.Gen.Model.End p0 p1 ->
            Evergreen.V18.Gen.Model.End p0 (p1 |> migrate_Pages_End_Model)

        Evergreen.V16.Gen.Model.Example p0 p1 ->
            Evergreen.V18.Gen.Model.Example p0 (p1 |> migrate_Pages_Example_Model)

        Evergreen.V16.Gen.Model.Home_ p0 p1 ->
            Evergreen.V18.Gen.Model.Home_ p0 (p1 |> migrate_Pages_Home__Model)

        Evergreen.V16.Gen.Model.Log p0 p1 ->
            Evergreen.V18.Gen.Model.Log p0 (p1 |> migrate_Pages_Log_Model)

        Evergreen.V16.Gen.Model.Login p0 p1 ->
            Evergreen.V18.Gen.Model.Login p0 (p1 |> migrate_Pages_Login_Model)

        Evergreen.V16.Gen.Model.NotFound p0 ->
            Evergreen.V18.Gen.Model.NotFound p0

        Evergreen.V16.Gen.Model.Register p0 p1 ->
            Evergreen.V18.Gen.Model.Register p0 (p1 |> migrate_Pages_Register_Model)

        Evergreen.V16.Gen.Model.Channel__Id_ p0 p1 ->
            Evergreen.V18.Gen.Model.Channel__Id_ (p0 |> migrate_Gen_Params_Channel_Id__Params)
                (p1 |> migrate_Pages_Channel_Id__Model)

        Evergreen.V16.Gen.Model.Ga__Email_ p0 p1 ->
            Evergreen.V18.Gen.Model.Ga__Email_ (p0 |> migrate_Gen_Params_Ga_Email__Params)
                (p1 |> migrate_Pages_Ga_Email__Model)

        Evergreen.V16.Gen.Model.Playlist__Id_ p0 p1 ->
            Evergreen.V18.Gen.Model.Playlist__Id_ (p0 |> migrate_Gen_Params_Playlist_Id__Params)
                (p1 |> migrate_Pages_Playlist_Id__Model)


migrate_Gen_Msg_Msg : Evergreen.V16.Gen.Msg.Msg -> Evergreen.V18.Gen.Msg.Msg
migrate_Gen_Msg_Msg old =
    case old of
        Evergreen.V16.Gen.Msg.Admin p0 ->
            Evergreen.V18.Gen.Msg.Admin (p0 |> migrate_Pages_Admin_Msg)

        Evergreen.V16.Gen.Msg.End p0 ->
            Evergreen.V18.Gen.Msg.End (p0 |> migrate_Pages_End_Msg)

        Evergreen.V16.Gen.Msg.Example p0 ->
            Evergreen.V18.Gen.Msg.Example (p0 |> migrate_Pages_Example_Msg)

        Evergreen.V16.Gen.Msg.Home_ p0 ->
            Evergreen.V18.Gen.Msg.Home_ (p0 |> migrate_Pages_Home__Msg)

        Evergreen.V16.Gen.Msg.Log p0 ->
            Evergreen.V18.Gen.Msg.Log (p0 |> migrate_Pages_Log_Msg)

        Evergreen.V16.Gen.Msg.Login p0 ->
            Evergreen.V18.Gen.Msg.Login (p0 |> migrate_Pages_Login_Msg)

        Evergreen.V16.Gen.Msg.Register p0 ->
            Evergreen.V18.Gen.Msg.Register (p0 |> migrate_Pages_Register_Msg)

        Evergreen.V16.Gen.Msg.Channel__Id_ p0 ->
            Evergreen.V18.Gen.Msg.Channel__Id_ (p0 |> migrate_Pages_Channel_Id__Msg)

        Evergreen.V16.Gen.Msg.Ga__Email_ p0 ->
            Evergreen.V18.Gen.Msg.Ga__Email_ (p0 |> migrate_Pages_Ga_Email__Msg)

        Evergreen.V16.Gen.Msg.Playlist__Id_ p0 ->
            Evergreen.V18.Gen.Msg.Playlist__Id_ (p0 |> migrate_Pages_Playlist_Id__Msg)


migrate_Gen_Pages_Model : Evergreen.V16.Gen.Pages.Model -> Evergreen.V18.Gen.Pages.Model
migrate_Gen_Pages_Model old =
    old |> migrate_Gen_Model_Model


migrate_Gen_Pages_Msg : Evergreen.V16.Gen.Pages.Msg -> Evergreen.V18.Gen.Pages.Msg
migrate_Gen_Pages_Msg old =
    old |> migrate_Gen_Msg_Msg


migrate_Gen_Params_Channel_Id__Params : Evergreen.V16.Gen.Params.Channel.Id_.Params -> Evergreen.V18.Gen.Params.Channel.Id_.Params
migrate_Gen_Params_Channel_Id__Params old =
    old


migrate_Gen_Params_Ga_Email__Params : Evergreen.V16.Gen.Params.Ga.Email_.Params -> Evergreen.V18.Gen.Params.Ga.Email_.Params
migrate_Gen_Params_Ga_Email__Params old =
    old


migrate_Gen_Params_Playlist_Id__Params : Evergreen.V16.Gen.Params.Playlist.Id_.Params -> Evergreen.V18.Gen.Params.Playlist.Id_.Params
migrate_Gen_Params_Playlist_Id__Params old =
    old


migrate_Json_Auto_PlaylistItems_Root : Evergreen.V16.Json.Auto.PlaylistItems.Root -> Evergreen.V18.Json.Auto.PlaylistItems.Root
migrate_Json_Auto_PlaylistItems_Root old =
    { etag = old.etag
    , items = old.items |> List.map migrate_Json_Auto_PlaylistItems_RootItemsObject
    , kind = old.kind
    , nextPageToken = old.nextPageToken
    , pageInfo = old.pageInfo |> migrate_Json_Auto_PlaylistItems_RootPageInfo
    }


migrate_Json_Auto_PlaylistItems_RootItemsObject : Evergreen.V16.Json.Auto.PlaylistItems.RootItemsObject -> Evergreen.V18.Json.Auto.PlaylistItems.RootItemsObject
migrate_Json_Auto_PlaylistItems_RootItemsObject old =
    { etag = old.etag
    , id = old.id
    , kind = old.kind
    , snippet = old.snippet |> migrate_Json_Auto_PlaylistItems_RootItemsObjectSnippet
    }


migrate_Json_Auto_PlaylistItems_RootItemsObjectSnippet : Evergreen.V16.Json.Auto.PlaylistItems.RootItemsObjectSnippet -> Evergreen.V18.Json.Auto.PlaylistItems.RootItemsObjectSnippet
migrate_Json_Auto_PlaylistItems_RootItemsObjectSnippet old =
    { channelId = old.channelId
    , channelTitle = old.channelTitle
    , description = old.description
    , playlistId = old.playlistId
    , position = old.position
    , publishedAt = old.publishedAt
    , resourceId = old.resourceId |> migrate_Json_Auto_PlaylistItems_RootItemsObjectSnippetResourceId
    , thumbnails = old.thumbnails |> Just
    , title = old.title
    }


migrate_Json_Auto_PlaylistItems_RootItemsObjectSnippetResourceId : Evergreen.V16.Json.Auto.PlaylistItems.RootItemsObjectSnippetResourceId -> Evergreen.V18.Json.Auto.PlaylistItems.RootItemsObjectSnippetResourceId
migrate_Json_Auto_PlaylistItems_RootItemsObjectSnippetResourceId old =
    old


migrate_Json_Auto_PlaylistItems_RootPageInfo : Evergreen.V16.Json.Auto.PlaylistItems.RootPageInfo -> Evergreen.V18.Json.Auto.PlaylistItems.RootPageInfo
migrate_Json_Auto_PlaylistItems_RootPageInfo old =
    old


migrate_Json_Bespoke_VideoDecoder_PageInfo : Evergreen.V16.Json.Bespoke.VideoDecoder.PageInfo -> Evergreen.V18.Json.Bespoke.VideoDecoder.PageInfo
migrate_Json_Bespoke_VideoDecoder_PageInfo old =
    old


migrate_Json_Bespoke_VideoDecoder_Root : Evergreen.V16.Json.Bespoke.VideoDecoder.Root -> Evergreen.V18.Json.Bespoke.VideoDecoder.Root
migrate_Json_Bespoke_VideoDecoder_Root old =
    { kind = old.kind
    , etag = old.etag
    , items = old.items |> List.map migrate_Json_Bespoke_VideoDecoder_Video
    , nextPageToken = Nothing
    , pageInfo = old.pageInfo |> migrate_Json_Bespoke_VideoDecoder_PageInfo
    }


migrate_Json_Bespoke_VideoDecoder_Snippet : Evergreen.V16.Json.Bespoke.VideoDecoder.Snippet -> Evergreen.V18.Json.Bespoke.VideoDecoder.Snippet
migrate_Json_Bespoke_VideoDecoder_Snippet old =
    { publishedAt = old.publishedAt
    , channelId = old.channelId
    , title = old.title
    , description = old.description
    , thumbnails = old.thumbnails
    , channelTitle = old.channelTitle
    , tags = old.tags
    , liveChatId = Nothing
    }


migrate_Json_Bespoke_VideoDecoder_Video : Evergreen.V16.Json.Bespoke.VideoDecoder.Video -> Evergreen.V18.Json.Bespoke.VideoDecoder.Video
migrate_Json_Bespoke_VideoDecoder_Video old =
    { kind = old.kind
    , etag = old.etag
    , id = old.id
    , snippet = old.snippet |> Maybe.map migrate_Json_Bespoke_VideoDecoder_Snippet
    , statistics = old.statistics
    , liveStreamingDetails = old.liveStreamingDetails
    }


migrate_Pages_Admin_Model : Evergreen.V16.Pages.Admin.Model -> Evergreen.V18.Pages.Admin.Model
migrate_Pages_Admin_Model old =
    old


migrate_Pages_Admin_Msg : Evergreen.V16.Pages.Admin.Msg -> Evergreen.V18.Pages.Admin.Msg
migrate_Pages_Admin_Msg old =
    case old of
        Evergreen.V16.Pages.Admin.ReplaceMe ->
            Evergreen.V18.Pages.Admin.ReplaceMe


migrate_Pages_Channel_Id__Model : Evergreen.V16.Pages.Channel.Id_.Model -> Evergreen.V18.Pages.Channel.Id_.Model
migrate_Pages_Channel_Id__Model old =
    old


migrate_Pages_Channel_Id__Msg : Evergreen.V16.Pages.Channel.Id_.Msg -> Evergreen.V18.Pages.Channel.Id_.Msg
migrate_Pages_Channel_Id__Msg old =
    case old of
        Evergreen.V16.Pages.Channel.Id_.GotChannelAndPlaylists p0 p1 p2 ->
            Evergreen.V18.Pages.Channel.Id_.GotChannelAndPlaylists (p0 |> migrate_Api_YoutubeModel_Channel) p1 p2

        Evergreen.V16.Pages.Channel.Id_.GetPlaylists ->
            Evergreen.V18.Pages.Channel.Id_.GetPlaylists

        Evergreen.V16.Pages.Channel.Id_.Schedule_UpdateSchedule p0 ->
            Evergreen.V18.Pages.Channel.Id_.Schedule_UpdateSchedule (p0 |> migrate_Api_YoutubeModel_Schedule)

        Evergreen.V16.Pages.Channel.Id_.MonitorPlaylist p0 p1 ->
            Evergreen.V18.Pages.Channel.Id_.MonitorPlaylist (p0 |> migrate_Api_YoutubeModel_Playlist) p1


migrate_Pages_End_Model : Evergreen.V16.Pages.End.Model -> Evergreen.V18.Pages.End.Model
migrate_Pages_End_Model old =
    old


migrate_Pages_End_Msg : Evergreen.V16.Pages.End.Msg -> Evergreen.V18.Pages.End.Msg
migrate_Pages_End_Msg old =
    case old of
        Evergreen.V16.Pages.End.ReplaceMe ->
            Evergreen.V18.Pages.End.ReplaceMe


migrate_Pages_Example_Model : Evergreen.V16.Pages.Example.Model -> Evergreen.V18.Pages.Example.Model
migrate_Pages_Example_Model old =
    old


migrate_Pages_Example_Msg : Evergreen.V16.Pages.Example.Msg -> Evergreen.V18.Pages.Example.Msg
migrate_Pages_Example_Msg old =
    case old of
        Evergreen.V16.Pages.Example.GotCredentials p0 ->
            Evergreen.V18.Pages.Example.GotCredentials p0

        Evergreen.V16.Pages.Example.GetChannels p0 ->
            Evergreen.V18.Pages.Example.GetChannels p0

        Evergreen.V16.Pages.Example.Tick p0 ->
            Evergreen.V18.Pages.Example.Tick p0


migrate_Pages_Ga_Email__Model : Evergreen.V16.Pages.Ga.Email_.Model -> Evergreen.V18.Pages.Ga.Email_.Model
migrate_Pages_Ga_Email__Model old =
    old


migrate_Pages_Ga_Email__Msg : Evergreen.V16.Pages.Ga.Email_.Msg -> Evergreen.V18.Pages.Ga.Email_.Msg
migrate_Pages_Ga_Email__Msg old =
    case old of
        Evergreen.V16.Pages.Ga.Email_.GotChannels p0 ->
            Evergreen.V18.Pages.Ga.Email_.GotChannels p0

        Evergreen.V16.Pages.Ga.Email_.GetChannels ->
            Evergreen.V18.Pages.Ga.Email_.GetChannels


migrate_Pages_Home__Model : Evergreen.V16.Pages.Home_.Model -> Evergreen.V18.Pages.Home_.Model
migrate_Pages_Home__Model old =
    old


migrate_Pages_Home__Msg : Evergreen.V16.Pages.Home_.Msg -> Evergreen.V18.Pages.Home_.Msg
migrate_Pages_Home__Msg old =
    case old of
        Evergreen.V16.Pages.Home_.Noop ->
            Evergreen.V18.Pages.Home_.Noop


migrate_Pages_Log_Model : Evergreen.V16.Pages.Log.Model -> Evergreen.V18.Pages.Log.Model
migrate_Pages_Log_Model old =
    { logs = old.logs |> List.map migrate_Api_Logging_LogEntry
    }


migrate_Pages_Log_Msg : Evergreen.V16.Pages.Log.Msg -> Evergreen.V18.Pages.Log.Msg
migrate_Pages_Log_Msg old =
    case old of
        Evergreen.V16.Pages.Log.GotLogs p0 ->
            Evergreen.V18.Pages.Log.GotLogs (p0 |> List.map migrate_Api_Logging_LogEntry)


migrate_Pages_Login_Field : Evergreen.V16.Pages.Login.Field -> Evergreen.V18.Pages.Login.Field
migrate_Pages_Login_Field old =
    case old of
        Evergreen.V16.Pages.Login.Email ->
            Evergreen.V18.Pages.Login.Email

        Evergreen.V16.Pages.Login.Password ->
            Evergreen.V18.Pages.Login.Password


migrate_Pages_Login_Model : Evergreen.V16.Pages.Login.Model -> Evergreen.V18.Pages.Login.Model
migrate_Pages_Login_Model old =
    old


migrate_Pages_Login_Msg : Evergreen.V16.Pages.Login.Msg -> Evergreen.V18.Pages.Login.Msg
migrate_Pages_Login_Msg old =
    case old of
        Evergreen.V16.Pages.Login.Updated p0 p1 ->
            Evergreen.V18.Pages.Login.Updated (p0 |> migrate_Pages_Login_Field) p1

        Evergreen.V16.Pages.Login.ToggledShowPassword ->
            Evergreen.V18.Pages.Login.ToggledShowPassword

        Evergreen.V16.Pages.Login.ClickedSubmit ->
            Evergreen.V18.Pages.Login.ClickedSubmit

        Evergreen.V16.Pages.Login.GotUser p0 ->
            Evergreen.V18.Pages.Login.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Pages_Playlist_Id__Model : Evergreen.V16.Pages.Playlist.Id_.Model -> Evergreen.V18.Pages.Playlist.Id_.Model
migrate_Pages_Playlist_Id__Model old =
    { playlistId = old.playlistId
    , playlistTitle = old.playlistTitle
    , videos = old.videos |> Dict.map (\k -> migrate_Api_YoutubeModel_Video)
    , liveVideoDetails = old.liveVideoDetails
    , currentViewers = old.currentViewers
    , videoChannels = Dict.empty
    }


migrate_Pages_Playlist_Id__Msg : Evergreen.V16.Pages.Playlist.Id_.Msg -> Evergreen.V18.Pages.Playlist.Id_.Msg
migrate_Pages_Playlist_Id__Msg old =
    case old of
        Evergreen.V16.Pages.Playlist.Id_.GotVideos p0 p1 p2 p3 ->
            Evergreen.V18.Pages.Playlist.Id_.GotVideos (p0 |> migrate_Api_YoutubeModel_Playlist)
                (p1 |> Dict.map (\k -> migrate_Api_YoutubeModel_Video))
                p2
                p3
                Dict.empty

        Evergreen.V16.Pages.Playlist.Id_.GetVideos ->
            Evergreen.V18.Pages.Playlist.Id_.GetVideos


migrate_Pages_Register_Field : Evergreen.V16.Pages.Register.Field -> Evergreen.V18.Pages.Register.Field
migrate_Pages_Register_Field old =
    case old of
        Evergreen.V16.Pages.Register.Email ->
            Evergreen.V18.Pages.Register.Email

        Evergreen.V16.Pages.Register.Password ->
            Evergreen.V18.Pages.Register.Password


migrate_Pages_Register_Model : Evergreen.V16.Pages.Register.Model -> Evergreen.V18.Pages.Register.Model
migrate_Pages_Register_Model old =
    old


migrate_Pages_Register_Msg : Evergreen.V16.Pages.Register.Msg -> Evergreen.V18.Pages.Register.Msg
migrate_Pages_Register_Msg old =
    case old of
        Evergreen.V16.Pages.Register.Updated p0 p1 ->
            Evergreen.V18.Pages.Register.Updated (p0 |> migrate_Pages_Register_Field) p1

        Evergreen.V16.Pages.Register.ToggledShowPassword ->
            Evergreen.V18.Pages.Register.ToggledShowPassword

        Evergreen.V16.Pages.Register.ClickedSubmit ->
            Evergreen.V18.Pages.Register.ClickedSubmit

        Evergreen.V16.Pages.Register.GotUser p0 ->
            Evergreen.V18.Pages.Register.GotUser (p0 |> migrate_Api_Data_Data migrate_Api_User_User)


migrate_Shared_Model : Evergreen.V16.Shared.Model -> Evergreen.V18.Shared.Model
migrate_Shared_Model old =
    { viewWidth = old.viewWidth
    , user = old.user |> Maybe.map migrate_Api_User_User
    , toastMessage = old.toastMessage
    }


migrate_Shared_Msg : Evergreen.V16.Shared.Msg -> Evergreen.V18.Shared.Msg
migrate_Shared_Msg old =
    case old of
        Evergreen.V16.Shared.GotViewWidth p0 ->
            Evergreen.V18.Shared.GotViewWidth p0

        Evergreen.V16.Shared.Noop ->
            Evergreen.V18.Shared.Noop

        Evergreen.V16.Shared.SignInUser p0 ->
            Evergreen.V18.Shared.SignInUser (p0 |> migrate_Api_User_User)

        Evergreen.V16.Shared.SignOutUser ->
            Evergreen.V18.Shared.SignOutUser

        Evergreen.V16.Shared.ShowToastMessage p0 ->
            Evergreen.V18.Shared.ShowToastMessage p0

        Evergreen.V16.Shared.HideToastMessage p0 ->
            Evergreen.V18.Shared.HideToastMessage p0


migrate_Types_BackendMsg : Evergreen.V16.Types.BackendMsg -> Evergreen.V18.Types.BackendMsg
migrate_Types_BackendMsg old =
    case old of
        Evergreen.V16.Types.OnConnect p0 p1 ->
            Evergreen.V18.Types.OnConnect p0 p1

        Evergreen.V16.Types.AuthenticateSession p0 p1 p2 p3 ->
            Evergreen.V18.Types.AuthenticateSession p0 p1 (p2 |> migrate_Api_User_User) p3

        Evergreen.V16.Types.VerifySession p0 p1 p2 ->
            Evergreen.V18.Types.VerifySession p0 p1 p2

        Evergreen.V16.Types.RegisterUser p0 p1 p2 p3 ->
            Evergreen.V18.Types.RegisterUser p0 p1 p2 p3

        Evergreen.V16.Types.Log_ p0 p1 p2 ->
            Evergreen.V18.Types.Log_ p0 (p1 |> migrate_Api_Logging_LogLevel) p2

        Evergreen.V16.Types.GotFreshAccessTokenWithTime p0 p1 p2 ->
            Evergreen.V18.Types.GotFreshAccessTokenWithTime p0 p1 p2

        Evergreen.V16.Types.Batch_RefreshAccessTokens p0 ->
            Evergreen.V18.Types.Batch_RefreshAccessTokens p0

        Evergreen.V16.Types.Batch_RefreshAllChannels p0 ->
            Evergreen.V18.Types.Batch_RefreshAllChannels p0

        Evergreen.V16.Types.Batch_RefreshAllPlaylists p0 ->
            Evergreen.V18.Types.Batch_RefreshAllPlaylists p0

        Evergreen.V16.Types.Batch_RefreshAllVideos p0 ->
            Evergreen.V18.Types.Batch_RefreshAllVideos p0

        Evergreen.V16.Types.Batch_GetLiveVideoStreamData p0 ->
            Evergreen.V18.Types.Batch_GetLiveVideoStreamData p0

        Evergreen.V16.Types.GetAccessToken p0 p1 ->
            Evergreen.V18.Types.GetAccessToken p0 p1

        Evergreen.V16.Types.GotAccessToken p0 p1 p2 ->
            Evergreen.V18.Types.GotAccessToken p0 p1 p2

        Evergreen.V16.Types.GetChannelsByCredential p0 ->
            Evergreen.V18.Types.GetChannelsByCredential p0

        Evergreen.V16.Types.GotChannels p0 p1 ->
            Evergreen.V18.Types.GotChannels p0 p1

        Evergreen.V16.Types.GetPlaylistsByChannel p0 ->
            Evergreen.V18.Types.GetPlaylistsByChannel p0

        Evergreen.V16.Types.GotPlaylists p0 p1 ->
            Evergreen.V18.Types.GotPlaylists p0 p1

        Evergreen.V16.Types.GetVideosByPlaylist p0 p1 ->
            Evergreen.V18.Types.GetVideosByPlaylist p0 p1

        Evergreen.V16.Types.GotVideosFromPlaylist p0 p1 ->
            Evergreen.V18.Types.GotVideosFromPlaylist p0
                (p1 |> Result.map migrate_Json_Auto_PlaylistItems_Root)

        Evergreen.V16.Types.GotLiveVideoStreamData p0 p1 p2 ->
            Evergreen.V18.Types.GotLiveVideoStreamData p0
                p1
                (p2 |> Result.map migrate_Json_Bespoke_VideoDecoder_Root)

        Evergreen.V16.Types.NoOpBackendMsg ->
            Evergreen.V18.Types.NoOpBackendMsg




migrate_Types_FrontendMsg : Evergreen.V16.Types.FrontendMsg -> Evergreen.V18.Types.FrontendMsg
migrate_Types_FrontendMsg old =
    case old of
        Evergreen.V16.Types.ChangedUrl p0 ->
            Evergreen.V18.Types.ChangedUrl p0

        Evergreen.V16.Types.ClickedLink p0 ->
            Evergreen.V18.Types.ClickedLink p0

        Evergreen.V16.Types.Shared p0 ->
            Evergreen.V18.Types.Shared (p0 |> migrate_Shared_Msg)

        Evergreen.V16.Types.Page p0 ->
            Evergreen.V18.Types.Page (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V16.Types.Noop ->
            Evergreen.V18.Types.Noop


migrate_Types_ToFrontend : Evergreen.V16.Types.ToFrontend -> Evergreen.V18.Types.ToFrontend
migrate_Types_ToFrontend old =
    case old of
        Evergreen.V16.Types.PageMsg p0 ->
            Evergreen.V18.Types.PageMsg (p0 |> migrate_Gen_Pages_Msg)

        Evergreen.V16.Types.SharedMsg p0 ->
            Evergreen.V18.Types.SharedMsg (p0 |> migrate_Shared_Msg)

        Evergreen.V16.Types.NoOpToFrontend ->
            Evergreen.V18.Types.NoOpToFrontend
