module Evergreen.V21.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V21.Api.YoutubeModel


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V21.Api.YoutubeModel.Video
    , liveVideoDetails : Dict.Dict String Evergreen.V21.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V21.Api.YoutubeModel.CurrentViewers
    , videoChannels : Dict.Dict String String
    , playlists : Dict.Dict String Evergreen.V21.Api.YoutubeModel.Playlist
    }


type Msg
    = GotVideos (Dict.Dict String Evergreen.V21.Api.YoutubeModel.Playlist) (Dict.Dict String Evergreen.V21.Api.YoutubeModel.Video) (Dict.Dict String Evergreen.V21.Api.YoutubeModel.LiveVideoDetails) (Dict.Dict ( String, Int ) Evergreen.V21.Api.YoutubeModel.CurrentViewers) (Dict.Dict String String)
    | GetVideos
