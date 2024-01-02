module Evergreen.V8.Pages.Channel.Id_ exposing (..)

import Dict
import Evergreen.V8.Api.YoutubeModel


type alias Model =
    { channelId : String
    , channel : Maybe Evergreen.V8.Api.YoutubeModel.Channel
    , playlists : Dict.Dict String Evergreen.V8.Api.YoutubeModel.Playlist
    , schedules : Dict.Dict String Evergreen.V8.Api.YoutubeModel.Schedule
    }


type Msg
    = GotChannelAndPlaylists Evergreen.V8.Api.YoutubeModel.Channel (Dict.Dict String Evergreen.V8.Api.YoutubeModel.Playlist) (Dict.Dict String Evergreen.V8.Api.YoutubeModel.Schedule)
    | GetPlaylists
    | Schedule_UpdateSchedule Evergreen.V8.Api.YoutubeModel.Schedule
