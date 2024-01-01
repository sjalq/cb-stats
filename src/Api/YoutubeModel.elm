module Api.YoutubeModel exposing (..)

import Set exposing (Set)

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

type alias Video =
    { id : String
    , title : String
    , description : String
    , channelId : String
    , playlistId : String
    , thumbnailUrl : String
    , publishedAt : String
    , duration : Int
    , viewCount : Int
    , likeCount : Int
    , dislikeCount : Int
    , favoriteCount : Int
    , commentCount : Int
    }