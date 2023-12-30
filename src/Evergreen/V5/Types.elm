module Evergreen.V5.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V5.Api.Logging
import Evergreen.V5.Api.User
import Evergreen.V5.Api.YoutubeModel
import Evergreen.V5.Bridge
import Evergreen.V5.Gen.Pages
import Evergreen.V5.Json.Auto.AccessToken
import Evergreen.V5.Json.Auto.Channels
import Evergreen.V5.Json.Auto.Playlists
import Evergreen.V5.Shared
import Http
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V5.Shared.Model
    , page : Evergreen.V5.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V5.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V5.Api.User.Email Evergreen.V5.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V5.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V5.Api.YoutubeModel.ClientCredentials
    , channels : Dict.Dict String Evergreen.V5.Api.YoutubeModel.Channel
    , channelAssociations : List Evergreen.V5.Api.YoutubeModel.ChannelAssociation
    , playlists : Dict.Dict String Evergreen.V5.Api.YoutubeModel.Playlist
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V5.Shared.Msg
    | Page Evergreen.V5.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V5.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V5.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V5.Api.Logging.LogLevel Time.Posix
    | FetchChannels String
    | FetchAccessToken String
    | GotAccessTokenResponse String Evergreen.V5.Json.Auto.AccessToken.Root
    | GotFreshAccessTokenWithTime String String Time.Posix
    | RefreshAccessTokens Time.Posix
    | RefreshChannels Time.Posix
    | RefreshPlaylists Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V5.Json.Auto.AccessToken.Root)
    | GetChannels String
    | GotChannels String (Result Http.Error Evergreen.V5.Json.Auto.Channels.Root)
    | GetPlaylists String
    | GotPlaylists String (Result Http.Error Evergreen.V5.Json.Auto.Playlists.Root)
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V5.Gen.Pages.Msg
    | SharedMsg Evergreen.V5.Shared.Msg
    | NoOpToFrontend
