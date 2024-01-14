module Evergreen.V22.Pages.Channel.Id_ exposing (..)

import Dict
import Evergreen.V22.Api.YoutubeModel


type alias Model =
    { channelId : String
    , channel : Maybe Evergreen.V22.Api.YoutubeModel.Channel
    , playlists : Dict.Dict String Evergreen.V22.Api.YoutubeModel.Playlist
    , latestVideos : Dict.Dict String Int
    , schedules : Dict.Dict String Evergreen.V22.Api.YoutubeModel.Schedule
    }


type Msg
    = GotChannelAndPlaylists Evergreen.V22.Api.YoutubeModel.Channel (Dict.Dict String Evergreen.V22.Api.YoutubeModel.Playlist) (Dict.Dict String Int) (Dict.Dict String Evergreen.V22.Api.YoutubeModel.Schedule)
    | GetPlaylists
    | Schedule_UpdateSchedule Evergreen.V22.Api.YoutubeModel.Schedule
    | MonitorPlaylist Evergreen.V22.Api.YoutubeModel.Playlist Bool
