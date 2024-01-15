module Evergreen.V28.Pages.Channel.Id_ exposing (..)

import Dict
import Evergreen.V28.Api.YoutubeModel


type alias Model =
    { channelId : String
    , channel : Maybe Evergreen.V28.Api.YoutubeModel.Channel
    , playlists : Dict.Dict String Evergreen.V28.Api.YoutubeModel.Playlist
    , latestVideos : Dict.Dict String Int
    , schedules : Dict.Dict String Evergreen.V28.Api.YoutubeModel.Schedule
    }


type Msg
    = GotChannelAndPlaylists Evergreen.V28.Api.YoutubeModel.Channel (Dict.Dict String Evergreen.V28.Api.YoutubeModel.Playlist) (Dict.Dict String Int) (Dict.Dict String Evergreen.V28.Api.YoutubeModel.Schedule)
    | GetPlaylists
    | Schedule_UpdateSchedule Evergreen.V28.Api.YoutubeModel.Schedule
    | MonitorPlaylist Evergreen.V28.Api.YoutubeModel.Playlist Bool
