module Evergreen.V16.Api.YoutubeModel exposing (..)

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
    | Ended
    | Impossibru


type alias Video =
    { id : String
    , title : String
    , description : String
    , channelId : String
    , playlistId : String
    , thumbnailUrl : String
    , publishedAt : String
    , liveStatus : LiveStatus
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
