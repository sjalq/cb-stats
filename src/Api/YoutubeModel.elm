module Api.YoutubeModel exposing (..)

import Dict exposing (Dict)
import Iso8601
import Json.Bespoke.VideoDecoder exposing (Statistics)
import Lamdera.Debug exposing (Posix)
import Set exposing (Set)
import Time
import Utils.Time exposing (..)


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
    , competitorHandles : Set String
    }


type alias Schedule =
    { playlistId : String
    , hour : Int
    , minute : Int
    , days : DaysOfWeek
    }


type alias Report =
    { averageViewPercentage : Float
    , subscribersGained : Int
    , subscribersLost : Int
    , views : Int
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
    | Uploaded
    | Scheduled String
    | Expired
    | Old
    | Live
    | Ended String
    | Impossibru


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
    , statsOnConclusion : Maybe Statistics
    , statsAfter24Hours : Maybe Statistics
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
    , timestamp : Posix
    , value : Int
    }


type alias VideoStatisticsAtTime =
    { videoId : String
    , timestamp : Posix
    , viewCount : Int
    , likeCount : Int
    , dislikeCount : Maybe Int
    , favoriteCount : Maybe Int
    , commentCount : Maybe Int
    }



-- competitors
-- competitors are playlists that contain the videos of other creators
-- we have to take the daily stats from that playlist and compare them to our own
-- so we have to look at videos that went were published or went live over the same time we went live


video_peakViewers currentViewers videoId =
    currentViewers
        |> Dict.filter (\( videoId_, _ ) _ -> videoId_ == videoId)
        |> Dict.values
        |> List.sortBy (\cv -> cv.value)
        |> List.reverse
        |> List.head
        |> Maybe.map .value


video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers minuteMark videoId =
    let
        liveStreamingDetails =
            liveVideoDetails
                |> Dict.get videoId

        actualStartTime =
            liveStreamingDetails
                |> Maybe.andThen .actualStartTime
                |> Maybe.andThen (Iso8601.toTime >> Result.toMaybe)
                |> Maybe.map Time.posixToMillis

        minuteOffset =
            actualStartTime
                |> Maybe.map (\actualStartTimePosix_ -> actualStartTimePosix_ + (minuteMark * minute))
                |> Maybe.withDefault 0

        listViewers =
            currentViewers
                |> Dict.filter (\( videoId_, _ ) _ -> videoId_ == videoId)
                |> Dict.values

        viewersAtMinuteOffset =
            listViewers
                |> List.filter (\cv -> (cv.timestamp |> Time.posixToMillis) < minuteOffset)
                |> List.sortBy (\cv -> cv.timestamp |> Time.posixToMillis)
                |> List.reverse
                |> List.head
                |> Maybe.map .value
    in
    viewersAtMinuteOffset

video_viewersAtXminuteMark liveStreamingDetails listViewers minuteMark =
    let
        actualStartTime =
            liveStreamingDetails
                |> Maybe.andThen .actualStartTime
                |> Maybe.andThen (Iso8601.toTime >> Result.toMaybe)
                |> Maybe.map Time.posixToMillis
                |> Debug.log "actualStartTime"

        minuteOffset =
            actualStartTime
                |> Maybe.map (\actualStartTimePosix_ -> actualStartTimePosix_ + (minuteMark * minute))
                |> Maybe.withDefault 0
                |> Debug.log "minuteOffset"

        viewersAtMinuteOffset =
            listViewers
                |> Debug.log "listViewers"
                |> List.filter (\cv -> (cv.timestamp |> Time.posixToMillis) < minuteOffset)
                |> Debug.log "filter"
                |> List.sortBy (\cv -> cv.timestamp |> Time.posixToMillis)
                |> List.reverse
                |> List.head
                |> Maybe.map .value
    in
    viewersAtMinuteOffset
