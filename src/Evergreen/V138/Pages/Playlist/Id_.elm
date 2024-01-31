module Evergreen.V138.Pages.Playlist.Id_ exposing (..)

import Dict
import Evergreen.V138.Api.YoutubeModel
import Time


type alias Model =
    { playlistId : String
    , playlistTitle : String
    , videos : Dict.Dict String Evergreen.V138.Api.YoutubeModel.Video
    , liveVideoDetails : Dict.Dict String Evergreen.V138.Api.YoutubeModel.LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) Evergreen.V138.Api.YoutubeModel.CurrentViewers
    , videoChannels : Dict.Dict String String
    , playlists : Dict.Dict String Evergreen.V138.Api.YoutubeModel.Playlist
    , videoStatisticsAtTime : Dict.Dict ( String, Int ) Evergreen.V138.Api.YoutubeModel.VideoStatisticsAtTime
    , competitorVideos : Dict.Dict String (Dict.Dict String Evergreen.V138.Api.YoutubeModel.Video)
    , currentIntTime : Int
    , tmpCtrs : Dict.Dict String String
    , tmpLiveViews : Dict.Dict String String
    , competingPercentages : List (Maybe Evergreen.V138.Api.YoutubeModel.CompetitorResult)
    }


type Msg
    = GotVideos Evergreen.V138.Api.YoutubeModel.VideoResults
    | GetVideos
    | UpdateVideoCTR String String
    | UpdateVideoLiveViews String String
    | Tick Time.Posix
    | GotCompetingPercentages (List (Maybe Evergreen.V138.Api.YoutubeModel.CompetitorResult))
