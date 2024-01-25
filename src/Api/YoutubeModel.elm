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


type LiveViewers
    = Estimate Int
    | Actual Int
    | Unknown_


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
    , videoStatisticsAtTime : Dict ( String, Int ) VideoStatisticsAtTime
    , competitorVideos : Dict String (Dict String Video)
    , competitorsVsUs : Dict String (Dict String (Maybe Float))
    }


type alias CompetitorResult =
    { videoId : String
    , competitorId : String
    , competitorTitle : String
    , percentage : Float
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
        peak =
            video_peakViewers currentViewers video.id

        liveLikes =
            video.statsOnConclusion |> Maybe.map .likeCount
    in
    Maybe.map2
        (\p l -> ((p * 12) + (l * 31)) // 10)
        peak
        liveLikes


video_liveViews video currentViewers =
    case video.liveViews of
        Nothing ->
            video_liveViewsEstimate
                video
                (currentViewers |> currentViewers_ListToDict)
                |> Maybe.map (\liveViews_ -> Estimate liveViews_)
                |> Maybe.withDefault Unknown_

        Just liveViews_ ->
            Actual liveViews_


video_lobbyEstimate liveVideoDetails currentViewers videoId =
    let
        min1 =
            video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers 60 videoId

        min2 =
            video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers (60 + 60) videoId
    in
    -- Maybe.map2
    --     (\m1 m2 -> ((m1 * 20) + (m2 * 80)) // 100)
    --     min1
    --     min2
    video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers 15 videoId


video_avgViewers liveVideoDetails currentViewers secondMark videoId =
    let
        min1 =
            video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers secondMark videoId

        min2 =
            video_viewersAtXminuteMarkFromDicts liveVideoDetails currentViewers (secondMark + 60) videoId
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


currentViewers_ListToDict currentViewers =
    currentViewers
        |> List.map (\c -> ( ( c.videoId, c.timestamp |> Time.posixToMillis ), c ))
        |> Dict.fromList


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



--findCompetingVideoStats : Model -> String -> String -> { ours : Maybe VideoStatisticsAtTime, theirs : Maybe VideoStatisticsAtTime }


findCompetingVideoStats model videoId competitorId =
    let
        -- goal:
        -- * for one video and one competitor video find the competing video that was live at the same time
        competitorVideos =
            model.videos
                |> Dict.filter (\_ v -> v.videoOwnerChannelId == competitorId)

        competitorLiveVideoDetails =
            model.liveVideoDetails
                |> Dict.filter (\_ lvd -> Dict.member lvd.videoId competitorVideos)

        -- big O n
        ourVideoLiveVideoDetails =
            model.liveVideoDetails
                |> Dict.get videoId

        -- big O n log n
        competitorVideosThatOverlap =
            competitorLiveVideoDetails
                |> Dict.filter
                    (\_ lvd ->
                        case ourVideoLiveVideoDetails of
                            Just ourVideoLiveVideoDetails_ ->
                                timespansOverlap
                                    (video_actualStartTime model ourVideoLiveVideoDetails_ - 3 * hour)
                                    (video_actualEndTime model ourVideoLiveVideoDetails_ + 3 * hour)
                                    (video_actualStartTime model lvd)
                                    (video_actualEndTime model lvd)

                            Nothing ->
                                False
                    )

        latestCompetitorVideoThatOverlaps =
            competitorVideosThatOverlap
                |> Dict.values
                |> List.sortBy (.actualEndTime >> Maybe.map strToIntTime >> Maybe.withDefault 0 >> (*) -1)
                |> List.head

        latestCompetitorVideoThatOverlapsStats =
            model.videoStatisticsAtTime
                |> Dict.filter (\_ s -> s.videoId == (latestCompetitorVideoThatOverlaps |> Maybe.map .videoId |> Maybe.withDefault "Nope"))
                |> Dict.values
                |> List.sortBy (.timestamp >> Time.posixToMillis >> (*) -1)
                |> List.head

        ourLatestVideoStats =
            model.videoStatisticsAtTime
                |> Dict.filter (\_ s -> s.videoId == videoId)
                |> Dict.values
                |> List.sortBy (.timestamp >> Time.posixToMillis >> (*) -1)
                |> List.head
    in
    { ours = ourLatestVideoStats, theirs = latestCompetitorVideoThatOverlapsStats }



--calculateCompetingViewsPercentage : Model -> String -> String -> Maybe Float


calculateCompetingViewsPercentage model videoId competingChannelId =
    let
        { ours, theirs } =
            findCompetingVideoStats model videoId competingChannelId

        percentage =
            case ( ours, theirs ) of
                ( Just ours_, Just theirs_ ) ->
                    -- if ((ours_.timestamp |> Time.posixToMillis) <= (currentTime - day)) && ((theirs_.timestamp |> Time.posixToMillis) <= (currentTime - day)) then
                    if theirs_.viewCount >= 0 then
                        ((ours_.viewCount |> toFloat) / (theirs_.viewCount |> toFloat)) - 1 |> Just

                    else
                        Nothing

                _ ->
                    Nothing

        -- ( Just ours_, Nothing ) ->
        --     Just 1000
        -- ( Nothing, Just theirs_ ) ->
        --     Just -1000
        -- ( Nothing, Nothing ) ->
        --     Just -5000
    in
    percentage


timespansOverlap aStart aEnd bStart bEnd =
    (aStart <= bEnd) && (bStart <= aEnd)


video_actualStartTime model liveVideoDetails =
    model.liveVideoDetails
        |> Dict.get liveVideoDetails.videoId
        |> Maybe.andThen .actualStartTime
        |> Maybe.map strToIntTime
        |> Maybe.withDefault 0


video_actualEndTime model liveVideoDetails =
    model.liveVideoDetails
        |> Dict.get liveVideoDetails.videoId
        |> Maybe.andThen .actualEndTime
        |> Maybe.map strToIntTime
        |> Maybe.withDefault 0
