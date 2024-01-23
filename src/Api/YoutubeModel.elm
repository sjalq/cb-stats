module Api.YoutubeModel exposing (..)

import Dict 
import Iso8601
import Json.Bespoke.VideoDecoder exposing (Statistics)
import Lamdera.Debug exposing (Posix)
import Set exposing (Set)
import Time
import Utils.Time exposing (..)
import Dict exposing (Dict)


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
    , competitorIds : Set String
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

type alias VideoResults =
    { playlists : Dict String Playlist
    , videos : Dict String Video
    , liveVideoDetails : Dict String LiveVideoDetails
    , currentViewers : Dict ( String, Int ) CurrentViewers
    , videoChannels : Dict String String
    , videoStats : Dict ( String, Int ) VideoStatisticsAtTime
    , competitorVideos : Dict String ( Dict String Video )
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

video_liveViewsEstimate video currentViewers = 
    let
        peak = video_peakViewers currentViewers video.id 
        liveLikes = video.statsOnConclusion |> Maybe.map .likeCount 
    in
    Maybe.map2
        (\p l -> (p * 12) + (l * 31) // 10 ) 
        peak
        liveLikes


video_lobbyEstimate liveVideoDetails currentViewers videoId =
    let
        min1 = video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers 60 videoId
        min2 = video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers (60 + 60) videoId
    in
    Maybe.map2 
        (\m1 m2 -> ((m1 * 20) + (m2 * 80)) // 100)
        min1
        min2



video_avgViewers liveVideoDetails currentViewers secondMark videoId =
    let
        min1 = video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers secondMark videoId
        min2 = video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers (secondMark + 60) videoId
    in
    Maybe.map2 
        (\m1 m2 -> (m1 + m2) // 2)
        min1
        min2

video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers secondMark videoId =
    let
        liveStreamingDetails =
            liveVideoDetails
                |> Dict.get videoId

        actualStartTime =
            liveStreamingDetails
                |> Maybe.andThen .actualStartTime
                |> Maybe.andThen (Iso8601.toTime >> Result.toMaybe)
                |> Maybe.map Time.posixToMillis

        secondOffset =
            actualStartTime
                |> Maybe.map (\actualStartTimePosix_ -> actualStartTimePosix_ + (secondMark * second))
                |> Maybe.withDefault 0

        listViewers =
            currentViewers
                |> Dict.filter (\( videoId_, _ ) _ -> videoId_ == videoId)
                |> Dict.values

        viewersAtMinuteOffset =
            listViewers
                |> List.filter (\cv -> (cv.timestamp |> Time.posixToMillis) < secondOffset)
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
                |> List.filter (\cv -> (cv.timestamp |> Time.posixToMillis) <= minuteOffset)
                |> Debug.log "filter"
                |> List.sortBy (\cv -> cv.timestamp |> Time.posixToMillis)
                |> List.reverse
                |> List.head
                |> Maybe.map .value
    in
    viewersAtMinuteOffset

liveStatusToString liveStatus =
    case liveStatus of
        Unknown ->
            "Unknown"

        Uploaded ->
            "Uploaded"

        Scheduled time ->
            "Scheduled for " ++ time

        Expired ->
            "Expired"

        Old ->
            "Old"

        Live ->
            "Live"

        Ended time ->
            "Ended " ++ time

        Impossibru ->
            "Impossibru"