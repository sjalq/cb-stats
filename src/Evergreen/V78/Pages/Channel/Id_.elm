module Evergreen.V78.Pages.Channel.Id_ exposing (..)

import Dict
import Evergreen.V78.Api.YoutubeModel


type alias Model =
    { channelId : String
    , channel : Maybe Evergreen.V78.Api.YoutubeModel.Channel
    , playlists : Dict.Dict String Evergreen.V78.Api.YoutubeModel.Playlist
    , latestVideos : Dict.Dict String Int
    , schedules : Dict.Dict String Evergreen.V78.Api.YoutubeModel.Schedule
    , tmpCompetitors : Dict.Dict String String
    }


type Msg
    = GotChannelAndPlaylists Evergreen.V78.Api.YoutubeModel.Channel (Dict.Dict String Evergreen.V78.Api.YoutubeModel.Playlist) (Dict.Dict String Int) (Dict.Dict String Evergreen.V78.Api.YoutubeModel.Schedule)
    | GetPlaylists
    | Schedule_UpdateSchedule Evergreen.V78.Api.YoutubeModel.Schedule
    | MonitorPlaylist Evergreen.V78.Api.YoutubeModel.Playlist Bool
    | Competitors Evergreen.V78.Api.YoutubeModel.Playlist String
