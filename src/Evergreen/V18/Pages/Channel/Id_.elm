module Evergreen.V18.Pages.Channel.Id_ exposing (..)

import Dict
import Evergreen.V18.Api.YoutubeModel


type alias Model =
    { channelId : String
    , channel : Maybe Evergreen.V18.Api.YoutubeModel.Channel
    , playlists : Dict.Dict String Evergreen.V18.Api.YoutubeModel.Playlist
    , schedules : Dict.Dict String Evergreen.V18.Api.YoutubeModel.Schedule
    }


type Msg
    = GotChannelAndPlaylists Evergreen.V18.Api.YoutubeModel.Channel (Dict.Dict String Evergreen.V18.Api.YoutubeModel.Playlist) (Dict.Dict String Evergreen.V18.Api.YoutubeModel.Schedule)
    | GetPlaylists
    | Schedule_UpdateSchedule Evergreen.V18.Api.YoutubeModel.Schedule
    | MonitorPlaylist Evergreen.V18.Api.YoutubeModel.Playlist Bool
