module Evergreen.V18.Json.Bespoke.VideoDecoder exposing (..)


type alias Statistics =
    { viewCount : Int
    , likeCount : Int
    , dislikeCount : Maybe Int
    , favoriteCount : Maybe Int
    , commentCount : Int
    }


type alias Thumbnail =
    { url : String
    , width : Int
    , height : Int
    }


type alias Snippet =
    { publishedAt : String
    , channelId : String
    , title : String
    , description : String
    , thumbnails : Maybe Thumbnail
    , channelTitle : String
    , tags : Maybe (List String)
    , liveChatId : Maybe String
    }


type alias LiveStreamingDetails =
    { actualStartTime : Maybe String
    , actualEndTime : Maybe String
    , scheduledStartTime : Maybe String
    , concurrentViewers : Maybe String
    , activeLiveChatId : Maybe String
    }


type alias Video =
    { kind : String
    , etag : String
    , id : String
    , snippet : Maybe Snippet
    , statistics : Maybe Statistics
    , liveStreamingDetails : Maybe LiveStreamingDetails
    }


type alias PageInfo =
    { totalResults : Int
    , resultsPerPage : Int
    }


type alias Root =
    { kind : String
    , etag : String
    , items : List Video
    , nextPageToken : Maybe String
    , pageInfo : PageInfo
    }
