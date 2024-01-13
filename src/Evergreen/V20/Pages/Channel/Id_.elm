module Evergreen.V20.Pages.Channel.Id_ exposing (..)

import Dict
import Evergreen.V20.Api.YoutubeModel


type alias Model =
    { channelId : String
    , channel : Maybe Evergreen.V20.Api.YoutubeModel.Channel
    , playlists : Dict.Dict String Evergreen.V20.Api.YoutubeModel.Playlist
    , schedules : Dict.Dict String Evergreen.V20.Api.YoutubeModel.Schedule
    }


type Msg
    = GotChannelAndPlaylists Evergreen.V20.Api.YoutubeModel.Channel (Dict.Dict String Evergreen.V20.Api.YoutubeModel.Playlist) (Dict.Dict String Evergreen.V20.Api.YoutubeModel.Schedule)
    | GetPlaylists
    | Schedule_UpdateSchedule Evergreen.V20.Api.YoutubeModel.Schedule
    | MonitorPlaylist Evergreen.V20.Api.YoutubeModel.Playlist Bool
