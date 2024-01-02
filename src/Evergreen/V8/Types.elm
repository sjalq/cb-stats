module Evergreen.V8.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V8.Api.Logging
import Evergreen.V8.Api.User
import Evergreen.V8.Api.YoutubeModel
import Evergreen.V8.Bridge
import Evergreen.V8.Gen.Pages
import Evergreen.V8.Json.Auto.AccessToken
import Evergreen.V8.Json.Auto.Channels
import Evergreen.V8.Json.Auto.PlaylistItems
import Evergreen.V8.Json.Auto.Playlists
import Evergreen.V8.Shared
import Http
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V8.Shared.Model
    , page : Evergreen.V8.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V8.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V8.Api.User.Email Evergreen.V8.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V8.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V8.Api.YoutubeModel.ClientCredentials
    , channels : Dict.Dict String Evergreen.V8.Api.YoutubeModel.Channel
    , channelAssociations : List Evergreen.V8.Api.YoutubeModel.ChannelAssociation
    , playlists : Dict.Dict String Evergreen.V8.Api.YoutubeModel.Playlist
    , schedules : Dict.Dict String Evergreen.V8.Api.YoutubeModel.Schedule
    , videos : Dict.Dict String Evergreen.V8.Api.YoutubeModel.Video
    , apiCallCount : Int
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V8.Shared.Msg
    | Page Evergreen.V8.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V8.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V8.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V8.Api.Logging.LogLevel Time.Posix
    | GotFreshAccessTokenWithTime String String Time.Posix
    | Batch_RefreshAccessTokens Time.Posix
    | Batch_RefreshAllChannels Time.Posix
    | Batch_RefreshAllPlaylists Time.Posix
    | Batch_RefreshAllVideos Time.Posix
    | GetAccessToken String Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V8.Json.Auto.AccessToken.Root)
    | GetChannels String
    | GotChannels String (Result Http.Error Evergreen.V8.Json.Auto.Channels.Root)
    | GetPlaylists String
    | GotPlaylists String (Result Http.Error Evergreen.V8.Json.Auto.Playlists.Root)
    | GetVideos String
    | GotVideos String (Result Http.Error Evergreen.V8.Json.Auto.PlaylistItems.Root)
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V8.Gen.Pages.Msg
    | SharedMsg Evergreen.V8.Shared.Msg
    | NoOpToFrontend
