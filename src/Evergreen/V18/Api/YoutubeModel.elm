module Evergreen.V18.Api.YoutubeModel exposing (..)

import Evergreen.V18.Json.Bespoke.VideoDecoder
import Lamdera.Debug


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
    | NeverLive
    | Scheduled String
    | Expired
    | Live
    | Ended String
    | Impossibru


type alias Report =
    { averageViewPercentage : Float
    , subscribersGained : Int
    , subscribersLost : Int
    }


type alias Video =
    { id : String
    , title : String
    , description : String
    , channelId : String
    , playlistId : String
    , thumbnailUrl : Maybe String
    , publishedAt : String
    , liveChatId : Maybe String
    , liveStatus : LiveStatus
    , statsOnConclusion : Maybe Evergreen.V18.Json.Bespoke.VideoDecoder.Statistics
    , statsAfter24Hours : Maybe Evergreen.V18.Json.Bespoke.VideoDecoder.Statistics
    , reportAfter24Hours : Maybe Report
    , chatMsgCount : Maybe Int
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


type alias ChannelAssociation =
    { email : String
    , channelId : String
    }
