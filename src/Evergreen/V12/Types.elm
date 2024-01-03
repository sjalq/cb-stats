module Evergreen.V12.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V12.Api.Logging
import Evergreen.V12.Api.User
import Evergreen.V12.Api.YoutubeModel
import Evergreen.V12.Bridge
import Evergreen.V12.Gen.Pages
import Evergreen.V12.Json.Auto.AccessToken
import Evergreen.V12.Json.Auto.Channels
import Evergreen.V12.Json.Auto.PlaylistItems
import Evergreen.V12.Json.Auto.Playlists
import Evergreen.V12.Shared
import Http
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V12.Shared.Model
    , page : Evergreen.V12.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V12.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V12.Api.User.Email Evergreen.V12.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V12.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V12.Api.YoutubeModel.ClientCredentials
    , channels : Dict.Dict String Evergreen.V12.Api.YoutubeModel.Channel
    , channelAssociations : List Evergreen.V12.Api.YoutubeModel.ChannelAssociation
    , playlists : Dict.Dict String Evergreen.V12.Api.YoutubeModel.Playlist
    , schedules : Dict.Dict String Evergreen.V12.Api.YoutubeModel.Schedule
    , videos : Dict.Dict String Evergreen.V12.Api.YoutubeModel.Video
    , apiCallCount : Int
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V12.Shared.Msg
    | Page Evergreen.V12.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V12.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V12.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V12.Api.Logging.LogLevel Time.Posix
    | GotFreshAccessTokenWithTime String String Time.Posix
    | Batch_RefreshAccessTokens Time.Posix
    | Batch_RefreshAllChannels Time.Posix
    | Batch_RefreshAllPlaylists Time.Posix
    | Batch_RefreshAllVideos Time.Posix
    | GetAccessToken String Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V12.Json.Auto.AccessToken.Root)
    | GetChannels String
    | GotChannels String (Result Http.Error Evergreen.V12.Json.Auto.Channels.Root)
    | GetPlaylists String
    | GotPlaylists String (Result Http.Error Evergreen.V12.Json.Auto.Playlists.Root)
    | GetVideos String
    | GotVideos String (Result Http.Error Evergreen.V12.Json.Auto.PlaylistItems.Root)
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V12.Gen.Pages.Msg
    | SharedMsg Evergreen.V12.Shared.Msg
    | NoOpToFrontend
