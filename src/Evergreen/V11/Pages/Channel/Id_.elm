module Evergreen.V11.Pages.Channel.Id_ exposing (..)

import Dict
import Evergreen.V11.Api.YoutubeModel


type alias Model =
    { channelId : String
    , channel : Maybe Evergreen.V11.Api.YoutubeModel.Channel
    , playlists : Dict.Dict String Evergreen.V11.Api.YoutubeModel.Playlist
    , schedules : Dict.Dict String Evergreen.V11.Api.YoutubeModel.Schedule
    }


type Msg
    = GotChannelAndPlaylists Evergreen.V11.Api.YoutubeModel.Channel (Dict.Dict String Evergreen.V11.Api.YoutubeModel.Playlist) (Dict.Dict String Evergreen.V11.Api.YoutubeModel.Schedule)
    | GetPlaylists
    | Schedule_UpdateSchedule Evergreen.V11.Api.YoutubeModel.Schedule
