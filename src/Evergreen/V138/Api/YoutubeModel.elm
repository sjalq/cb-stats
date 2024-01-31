module Evergreen.V138.Api.YoutubeModel exposing (..)

import Dict
import Evergreen.V138.Json.Bespoke.VideoDecoder
import Lamdera.Debug
import Set


type alias ClientCredentials =
    { displayName : String
    , email : String
    , accessToken : String
    , refreshToken : String
    , timestamp : Int
    }


type alias Channel =
    { id : String
    , title : String
    , description : String
    , customUrl : String
    }


type alias Playlist =
    { id : String
    , title : String
    , description : String
    , channelId : String
    , monitor : Bool
    , competitorHandles : Set.Set String
    , competitorIds : Set.Set String
    }


type alias DaysOfWeek =
    { monday : Bool
    , tuesday : Bool
    , wednesday : Bool
    , thursday : Bool
    , friday : Bool
    , saturday : Bool
    , sunday : Bool
    }


type alias Schedule =
    { playlistId : String
    , hour : Int
    , minute : Int
    , days : DaysOfWeek
    }


type LiveStatus
    = Unknown
    | Uploaded
    | Scheduled String
    | Expired
    | Old
    | Live
    | Ended String
    | Impossibru


type alias Report =
    { averageViewPercentage : Float
    , subscribersGained : Int
    , subscribersLost : Int
    , views : Int
    }


type alias Video =
    { id : String
    , title : String
    , description : String
    , videoOwnerChannelId : String
    , videoOwnerChannelTitle : String
    , playlistId : String
    , thumbnailUrl : Maybe String
    , publishedAt : String
    , liveChatId : Maybe String
    , liveStatus : LiveStatus
    , statsOnConclusion : Maybe Evergreen.V138.Json.Bespoke.VideoDecoder.Statistics
    , statsAfter24Hours : Maybe Evergreen.V138.Json.Bespoke.VideoDecoder.Statistics
    , reportAfter24Hours : Maybe Report
    , chatMsgCount : Maybe Int
    , ctr : Maybe Float
    , liveViews : Maybe Int
    }


type alias LiveVideoDetails =
    { videoId : String
    , scheduledStartTime : String
    , actualStartTime : Maybe String
    , actualEndTime : Maybe String
    }


type alias CurrentViewers =
    { videoId : String
    , timestamp : Lamdera.Debug.Posix
    , value : Int
    }


type alias VideoStatisticsAtTime =
    { videoId : String
    , timestamp : Lamdera.Debug.Posix
    , viewCount : Int
    , likeCount : Int
    , dislikeCount : Maybe Int
    , favoriteCount : Maybe Int
    , commentCount : Maybe Int
    }


type alias CompetitorResult =
    { videoId : String
    , competitorId : String
    , competitorTitle : String
    , percentage : Float
    }


type alias ChannelAssociation =
    { email : String
    , channelId : String
    }


type alias VideoResults =
    { playlists : Dict.Dict String Playlist
    , videos : Dict.Dict String Video
    , liveVideoDetails : Dict.Dict String LiveVideoDetails
    , currentViewers : Dict.Dict ( String, Int ) CurrentViewers
    , videoChannels : Dict.Dict String String
    , videoStatisticsAtTime : Dict.Dict ( String, Int ) VideoStatisticsAtTime
    , competitorVideos : Dict.Dict String (Dict.Dict String Video)
    , competitorsVsUs : Dict.Dict String (Dict.Dict String (Maybe Float))
    }
