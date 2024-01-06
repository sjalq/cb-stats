module Evergreen.V16.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V16.Api.Logging
import Evergreen.V16.Api.User
import Evergreen.V16.Api.YoutubeModel
import Evergreen.V16.Bridge
import Evergreen.V16.Gen.Pages
import Evergreen.V16.Json.Auto.AccessToken
import Evergreen.V16.Json.Auto.Channels
import Evergreen.V16.Json.Auto.PlaylistItems
import Evergreen.V16.Json.Auto.Playlists
import Evergreen.V16.Json.Bespoke.VideoDecoder
import Evergreen.V16.Shared
import Http
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V16.Shared.Model
    , page : Evergreen.V16.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V16.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V16.Api.User.Email Evergreen.V16.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V16.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V16.Api.YoutubeModel.ClientCredentials
    , channels : Dict.Dict String Evergreen.V16.Api.YoutubeModel.Channel
    , channelAssociations : List Evergreen.V16.Api.YoutubeModel.ChannelAssociation
    , playlists : Dict.Dict String Evergreen.V16.Api.YoutubeModel.Playlist
    , schedules : Dict.Dict String Evergreen.V16.Api.YoutubeModel.Schedule
    , videos : Dict.Dict String Evergreen.V16.Api.YoutubeModel.Video
    , liveVideoDetails : Dict.Dict String Evergreen.V16.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V16.Api.YoutubeModel.CurrentViewers
    , apiCallCount : Int
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V16.Shared.Msg
    | Page Evergreen.V16.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V16.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V16.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V16.Api.Logging.LogLevel Time.Posix
    | GotFreshAccessTokenWithTime String String Time.Posix
    | Batch_RefreshAccessTokens Time.Posix
    | Batch_RefreshAllChannels Time.Posix
    | Batch_RefreshAllPlaylists Time.Posix
    | Batch_RefreshAllVideos Time.Posix
    | Batch_GetLiveVideoStreamData Time.Posix
    | GetAccessToken String Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V16.Json.Auto.AccessToken.Root)
    | GetChannelsByCredential String
    | GotChannels String (Result Http.Error Evergreen.V16.Json.Auto.Channels.Root)
    | GetPlaylistsByChannel String
    | GotPlaylists String (Result Http.Error Evergreen.V16.Json.Auto.Playlists.Root)
    | GetVideosByPlaylist (Maybe String) String
    | GotVideosFromPlaylist String (Result Http.Error Evergreen.V16.Json.Auto.PlaylistItems.Root)
    | GotLiveVideoStreamData Time.Posix String (Result Http.Error Evergreen.V16.Json.Bespoke.VideoDecoder.Root)
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V16.Gen.Pages.Msg
    | SharedMsg Evergreen.V16.Shared.Msg
    | NoOpToFrontend
