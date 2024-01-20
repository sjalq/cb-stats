module Json.Bespoke.LiveBroadcastDecoder exposing (..)

import Json.Decode exposing (Decoder, int, list, maybe, string, succeed)
import Json.Decode.Pipeline exposing (optional, required)

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
    }

type alias Statistics =
    { viewCount : Int
    , likeCount : Int
    , dislikeCount : Maybe Int
    , favoriteCount : Maybe Int
    , commentCount : Int
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

type alias Root =
    { kind : String
    , etag : String
    , items : List Video
    , nextPageToken : Maybe String
    , pageInfo : PageInfo
    }

type alias PageInfo =
    { totalResults : Int
    , resultsPerPage : Int
    }

thumbnailDecoder : Decoder Thumbnail
thumbnailDecoder =
    succeed Thumbnail
        |> required "url" string
        |> required "width" int
        |> required "height" int

snippetDecoder : Decoder Snippet
snippetDecoder =
    succeed Snippet
        |> required "publishedAt" string
        |> required "channelId" string
        |> required "title" string
        |> required "description" string
        |> optional "thumbnails" (maybe thumbnailDecoder) Nothing
        |> required "channelTitle" string
        |> optional "tags" (maybe (list string)) Nothing

statisticsDecoder : Decoder Statistics
statisticsDecoder =
    succeed Statistics
        |> required "viewCount" int 
        |> required "likeCount" int 
        |> optional "dislikeCount" (maybe int) Nothing
        |> optional "favoriteCount" (maybe int) Nothing
        |> required "commentCount" int

liveStreamingDetailsDecoder : Decoder LiveStreamingDetails
liveStreamingDetailsDecoder =
    succeed LiveStreamingDetails
        |> optional "actualStartTime" (maybe string) Nothing
        |> optional "actualEndTime" (maybe string) Nothing
        |> optional "scheduledStartTime" (maybe string) Nothing
        |> optional "concurrentViewers" (maybe string) Nothing
        |> optional "activeLiveChatId" (maybe string) Nothing

videoDecoder : Decoder Video
videoDecoder =
    succeed Video
        |> required "kind" string
        |> required "etag" string
        |> required "id" string
        |> optional "snippet" (maybe snippetDecoder) Nothing
        |> optional "statistics" (maybe statisticsDecoder) Nothing
        |> optional "liveStreamingDetails" (maybe liveStreamingDetailsDecoder) Nothing

pageInfoDecoder : Decoder PageInfo
pageInfoDecoder =
    succeed PageInfo
        |> required "totalResults" int
        |> required "resultsPerPage" int

rootDecoder : Decoder Root
rootDecoder =
    succeed Root
        |> required "kind" string
        |> required "etag" string
        |> required "items" (list videoDecoder)
        |> optional "nextPageToken" (maybe string) Nothing
        |> required "pageInfo" pageInfoDecoder

