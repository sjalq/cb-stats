module Api.YoutubeModel exposing (..)

import Set exposing (Set)
import Lamdera.Debug exposing (Posix)
import Json.Bespoke.VideoDecoder exposing (Statistics)


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


type alias ChannelAssociation =
    { email : String
    , channelId : String
    }


type alias Playlist =
    { id : String
    , title : String
    , description : String
    , channelId : String
    , monitor : Bool -- this will check the playlist for live videos every 10 minutes
    }


type alias Schedule =
    { playlistId : String
    , hour : Int
    , minute : Int
    , days : DaysOfWeek
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


type LiveStatus 
    = Unknown
    | NeverLive
    | Scheduled String
    | Expired
    | Live
    | Ended String
    | Impossibru


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
    , statsOnConclusion : Maybe Statistics
    , statsAfter24Hours : Maybe Statistics
    , chatMsgCount : Maybe Int
    }


type alias VideoStats =
    { videoId : String
    , viewCount : Int
    , likeCount : Int
    , dislikeCount : Int
    , favoriteCount : Int
    , commentCount : Int
    }


type alias LiveVideoDetails =
    { videoId : String
    , scheduledStartTime : String
    , actualStartTime : Maybe String
    , actualEndTime : Maybe String
    }

type alias CurrentViewers =
    { videoId : String
    , timestamp : Posix
    , value : Int
    }

type alias VideoStatisticsAtTime =
    { videoId : String
    , timestamp : Posix
    , viewCount : Int
    , likeCount : Int
    , dislikeCount : Int
    , favoriteCount : Int
    , commentCount : Int
    }