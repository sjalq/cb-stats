module Evergreen.V6.Types exposing (..)

import Browser
import Browser.Navigation
import Dict
import Evergreen.V6.Api.Logging
import Evergreen.V6.Api.User
import Evergreen.V6.Api.YoutubeModel
import Evergreen.V6.Bridge
import Evergreen.V6.Gen.Pages
import Evergreen.V6.Json.Auto.AccessToken
import Evergreen.V6.Json.Auto.Channels
import Evergreen.V6.Json.Auto.Playlists
import Evergreen.V6.Shared
import Http
import Lamdera
import Time
import Url


type alias FrontendModel =
    { url : Url.Url
    , key : Browser.Navigation.Key
    , shared : Evergreen.V6.Shared.Model
    , page : Evergreen.V6.Gen.Pages.Model
    }


type alias Session =
    { user : Evergreen.V6.Api.User.Email
    , expires : Time.Posix
    }


type alias BackendModel =
    { users : Dict.Dict Evergreen.V6.Api.User.Email Evergreen.V6.Api.User.UserFull
    , authenticatedSessions : Dict.Dict Lamdera.SessionId Session
    , incrementedInt : Int
    , logs : List Evergreen.V6.Api.Logging.LogEntry
    , clientCredentials : Dict.Dict String Evergreen.V6.Api.YoutubeModel.ClientCredentials
    , channels : Dict.Dict String Evergreen.V6.Api.YoutubeModel.Channel
    , channelAssociations : List Evergreen.V6.Api.YoutubeModel.ChannelAssociation
    , playlists : Dict.Dict String Evergreen.V6.Api.YoutubeModel.Playlist
    }


type FrontendMsg
    = ChangedUrl Url.Url
    | ClickedLink Browser.UrlRequest
    | Shared Evergreen.V6.Shared.Msg
    | Page Evergreen.V6.Gen.Pages.Msg
    | Noop


type alias ToBackend =
    Evergreen.V6.Bridge.ToBackend


type BackendMsg
    = OnConnect Lamdera.SessionId Lamdera.ClientId
    | AuthenticateSession Lamdera.SessionId Lamdera.ClientId Evergreen.V6.Api.User.User Time.Posix
    | VerifySession Lamdera.SessionId Lamdera.ClientId Time.Posix
    | RegisterUser
        Lamdera.SessionId
        Lamdera.ClientId
        { email : String
        , password : String
        }
        String
    | Log_ String Evergreen.V6.Api.Logging.LogLevel Time.Posix
    | GotFreshAccessTokenWithTime String String Time.Posix
    | RefreshAccessTokens Time.Posix
    | RefreshAllChannels Time.Posix
    | RefreshAllPlaylists Time.Posix
    | GotAccessToken String Time.Posix (Result Http.Error Evergreen.V6.Json.Auto.AccessToken.Root)
    | GetChannels String
    | GotChannels String (Result Http.Error Evergreen.V6.Json.Auto.Channels.Root)
    | GetPlaylists String
    | GotPlaylists String (Result Http.Error Evergreen.V6.Json.Auto.Playlists.Root)
    | NoOpBackendMsg


type ToFrontend
    = PageMsg Evergreen.V6.Gen.Pages.Msg
    | SharedMsg Evergreen.V6.Shared.Msg
    | NoOpToFrontend
