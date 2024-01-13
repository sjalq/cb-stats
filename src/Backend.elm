module Backend exposing (..)

import Api.Data
import Api.Logging as Logging exposing (..)
import Api.PerformNow exposing (performNow, performNowWithTime)
import Api.Time exposing (..)
import Api.User
import Api.YoutubeModel
import BackendLogging exposing (log)
import Bridge exposing (..)
import Crypto.Hash
import Dict
import Dict.Extra as Dict
import Env
import Gen.Msg
import Http exposing (Error(..))
import Iso8601
import Lamdera exposing (..)
import List.Extra
import MoreDict
import Pages.Channel.Id_
import Pages.Example
import Pages.Ga.Email_
import Pages.Log
import Pages.Login
import Pages.Playlist.Id_
import Pages.Register
import Random
import Random.Char
import Random.String
import Shared exposing (Msg(..))
import String exposing (fromInt)
import Task
import Time
import Time.Extra as Time
import Types exposing (BackendModel, BackendMsg(..), FrontendMsg(..), ToFrontend(..), hasExpired)
import YouTubeApi



-- todo:
-- * add error logging for any and all external calls


type alias Model =
    BackendModel


app =
    Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = subscriptions
        }


init : ( Model, Cmd BackendMsg )
init =
    ( { users = Dict.empty
      , authenticatedSessions = Dict.empty
      , incrementedInt = 0
      , logs = []
      , clientCredentials = Dict.empty
      , channels = Dict.empty
      , channelAssociations = []
      , playlists = Dict.empty
      , schedules = Dict.empty
      , videos = Dict.empty
      , videoStatisticsAtTime = Dict.empty
      , liveVideoDetails = Dict.empty
      , currentViewers = Dict.empty
      , apiCallCount = 0
      }
    , Cmd.none
    )


pollingInterval =
    case Env.mode of
        Env.Development ->
            60 * second

        Env.Production ->
            1 * minute


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Time.every (10 * second) Batch_RefreshAccessTokens
        , Time.every day Batch_RefreshAllChannels
        , Time.every day Batch_RefreshAllPlaylists
        , Time.every minute Batch_RefreshAllVideosFromPlaylists
        , Time.every pollingInterval Batch_GetLiveVideoStreamData
        , Time.every minute Batch_GetVideoStats
        , Time.every (10 * second) Batch_GetVideoDailyReports
        , Time.every (10 * second) Batch_GetChatMessages
        , Time.every (10 * second) Batch_GetVideoStatisticsAtTime
        , onConnect OnConnect
        ]


update : BackendMsg -> Model -> ( Model, Cmd BackendMsg )
update msg model =
    case msg of
        OnConnect sessionId clientId ->
            ( model, Time.now |> Task.perform (VerifySession sessionId clientId) )

        AuthenticateSession sessionId clientId user now ->
            ( { model
                | authenticatedSessions =
                    model.authenticatedSessions
                        |> Dict.insert sessionId
                            { user = user.email
                            , expires = now |> Time.add Time.Hour 24 Time.utc
                            }
              }
            , sendToShared clientId <| SignInUser <| user
            )

        VerifySession sessionId clientId now ->
            let
                maybeVerifiedUser =
                    model.authenticatedSessions
                        |> Dict.get sessionId
                        |> Maybe.andThen
                            (\session ->
                                if session |> hasExpired now then
                                    Nothing

                                else
                                    model.users |> Dict.get session.user
                            )
            in
            case maybeVerifiedUser of
                Nothing ->
                    ( model, sendToShared clientId <| SignOutUser )

                Just user ->
                    ( model, sendToShared clientId <| SignInUser <| Api.User.toUser user )

        RegisterUser sessionId clientId user salt ->
            let
                newUser =
                    { email = user.email
                    , role =
                        if Api.User.isAdminEmail user.email then
                            Api.User.Admin

                        else if Api.User.isEditorEmail user.email then
                            Api.User.Editor

                        else
                            Api.User.Basic
                    , passwordHash = hashPassword user.password salt
                    , salt = salt
                    }
            in
            ( { model | users = model.users |> Dict.insert user.email newUser }
            , Cmd.batch
                [ sendToPage clientId <|
                    Gen.Msg.Register <|
                        Pages.Register.GotUser <|
                            Api.Data.Success <|
                                Api.User.toUser newUser
                , Time.now |> Task.perform (AuthenticateSession sessionId clientId <| Api.User.toUser newUser)
                ]
            )

        NoOpBackendMsg ->
            ( model, Cmd.none )

        Log_ logMessage lvl posix ->
            ( model |> Logging.logToModel logMessage posix lvl, Cmd.none )

        GotFreshAccessTokenWithTime email newAccessToken newTimestampPosix ->
            let
                newModel =
                    model.clientCredentials
                        |> Dict.get email
                        -- fetch the old credentials
                        |> Maybe.map (\old -> { old | accessToken = newAccessToken, timestamp = newTimestampPosix |> Time.posixToMillis })
                        -- update the access token
                        |> Maybe.map
                            (\new ->
                                { model | clientCredentials = model.clientCredentials |> Dict.insert email new }
                             -- insert the new credentials into the model
                            )
                        |> Maybe.withDefault model
            in
            ( newModel
            , Cmd.none
            )

        GotAccessToken email time accessTokenResponse ->
            case accessTokenResponse of
                Result.Ok accessToken ->
                    let
                        newModel =
                            model.clientCredentials
                                |> Dict.get email
                                -- fetch the old credentials
                                |> Maybe.map (\old -> { old | accessToken = accessToken.accessToken, timestamp = time |> Time.posixToMillis })
                                -- update the access token
                                |> Maybe.map (\new -> { model | clientCredentials = model.clientCredentials |> Dict.insert email new })
                                |> Maybe.withDefault model
                    in
                    ( newModel
                    , Cmd.none
                    )

                Result.Err error ->
                    ( model
                    , Cmd.none
                    )
                        |> log ("Failed to fetch access token for " ++ email ++ "\n" ++ httpErrToString error) Error

        Batch_RefreshAccessTokens time ->
            let
                fetches =
                    model.clientCredentials
                        |> Dict.values
                        |> List.filter (\c -> (c.timestamp + 3550000) < (time |> Time.posixToMillis))
                        |> List.map
                            (\c ->
                                YouTubeApi.refreshAccessTokenCmd Env.clientId Env.clientSecret c.refreshToken c.email time
                            )
            in
            ( model
            , Cmd.batch fetches
            )

        GetChannelsByCredential email ->
            let
                maybeAccessToken =
                    model.clientCredentials
                        |> Dict.get email
                        |> Maybe.map .accessToken

                fetch =
                    maybeAccessToken
                        |> Maybe.map
                            (\accessToken ->
                                YouTubeApi.getChannelsCmd email accessToken
                            )
                        |> Maybe.withDefault Cmd.none
            in
            ( model
            , fetch
            )

        GotChannels email channelResponse ->
            case channelResponse of
                Result.Ok channels ->
                    let
                        retrievedChannels =
                            channels.items
                                |> List.map
                                    (\c ->
                                        ( c.id
                                        , { id = c.id
                                          , title = c.snippet.title
                                          , description = c.snippet.description
                                          , customUrl = c.snippet.customUrl
                                          }
                                        )
                                    )
                                |> Dict.fromList

                        newChannels =
                            Dict.union retrievedChannels model.channels

                        newChannelAssociations =
                            retrievedChannels
                                |> Dict.keys
                                |> List.map (\channelId -> { email = email, channelId = channelId })
                                |> (++) model.channelAssociations
                                |> List.Extra.uniqueBy (\c -> c.email ++ ", " ++ c.channelId)

                        newModel =
                            { model
                                | channels = newChannels
                                , channelAssociations = newChannelAssociations
                            }
                    in
                    ( newModel
                    , Cmd.none
                    )

                Result.Err error ->
                    ( model
                    , Cmd.none
                    )
                        |> log ("Failed to fetch channels for : " ++ email ++ "\n" ++ httpErrToString error) Error

        GetPlaylistsByChannel channelId ->
            let
                maybeAccessToken =
                    model.channelAssociations
                        |> List.filter (\c -> c.channelId == channelId)
                        |> List.head
                        |> Maybe.map .email
                        |> Maybe.andThen (\email -> model.clientCredentials |> Dict.get email |> Maybe.map .accessToken)

                fetch =
                    maybeAccessToken
                        |> Maybe.map
                            (\accessToken ->
                                YouTubeApi.getPlaylistsCmd channelId accessToken
                            )
                        |> Maybe.withDefault Cmd.none
            in
            ( model
            , fetch
            )

        GotPlaylists channelId playlistResponse ->
            case playlistResponse of
                Result.Ok playlists ->
                    let
                        retrievedPlaylists =
                            playlists.items
                                |> List.map
                                    (\p ->
                                        ( p.id
                                        , { id = p.id
                                          , title = p.snippet.title
                                          , description = p.snippet.description
                                          , channelId = p.snippet.channelId
                                          , monitor = False
                                          }
                                        )
                                    )
                                |> Dict.fromList

                        newPlaylists =
                            MoreDict.fullOuterJoin retrievedPlaylists model.playlists
                                |> MoreDict.filterMapJoin
                                    identity
                                    identity
                                    (\( retrieved, current ) -> { retrieved | monitor = current.monitor })

                        newModel =
                            { model
                                | playlists = newPlaylists
                            }
                    in
                    ( newModel
                    , Cmd.none
                    )

                Result.Err error ->
                    ( model
                    , Cmd.none
                    )
                        |> log ("Failed to fetch playlists for channel : " ++ channelId ++ "\n" ++ httpErrToString error) Error

        Batch_RefreshAllChannels _ ->
            let
                fetches =
                    model.clientCredentials
                        |> Dict.keys
                        |> List.map GetChannelsByCredential
                        |> List.map performNow
            in
            ( model
            , fetches |> Cmd.batch
            )

        Batch_RefreshAllPlaylists _ ->
            let
                fetches =
                    model.channels
                        |> Dict.keys
                        |> List.map GetPlaylistsByChannel
                        |> List.map performNow
            in
            ( model
            , fetches |> Cmd.batch
            )

        Batch_RefreshAllVideosFromPlaylists _ ->
            let
                fetches =
                    model.playlists
                        |> Dict.keys
                        |> List.map (GetVideosByPlaylist Nothing)
                        |> List.map performNow
            in
            ( model, fetches |> Cmd.batch )

        GetVideosByPlaylist nextPageToken playlistId ->
            let
                maybeAccessToken =
                    model.playlists
                        |> Dict.get playlistId
                        |> Maybe.map .channelId
                        |> Maybe.andThen (\channelId -> model.channelAssociations |> List.filter (\c -> c.channelId == channelId) |> List.head |> Maybe.map .email)
                        |> Maybe.andThen (\email -> model.clientCredentials |> Dict.get email |> Maybe.map .accessToken)

                fetch =
                    maybeAccessToken
                        |> Maybe.map
                            (YouTubeApi.getVideosCmd nextPageToken playlistId)
                        |> Maybe.withDefault Cmd.none
            in
            ( model
            , fetch
            )

        GetAccessToken email time ->
            let
                maybeRefreshToken =
                    model.clientCredentials
                        |> Dict.get email
                        |> Maybe.map .refreshToken

                fetch =
                    maybeRefreshToken
                        |> Maybe.map
                            (\refreshToken ->
                                YouTubeApi.refreshAccessTokenCmd Env.clientId Env.clientSecret refreshToken email time
                            )
                        |> Maybe.withDefault Cmd.none
            in
            ( model
            , fetch
            )

        GotVideosFromPlaylist playlistId playlistItemResponse ->
            case playlistItemResponse of
                Ok validResponse ->
                    let
                        -- type alias Video =
                        --     { id : String
                        --     , title : String
                        --     , description : String
                        --     , channelId : String
                        --     , playlistId : String
                        --     , thumbnailUrl : String
                        --     , publishedAt : String
                        --     }
                        retrievedVideos =
                            validResponse.items
                                |> List.map
                                    (\v ->
                                        ( v.snippet.resourceId.videoId
                                        , { id = v.snippet.resourceId.videoId
                                          , title = v.snippet.title
                                          , description = v.snippet.description
                                          , channelId = v.snippet.channelId
                                          , playlistId = v.snippet.playlistId
                                          , thumbnailUrl = v.snippet.thumbnails |> Maybe.map (.standard >> .url)
                                          , publishedAt = v.snippet.publishedAt
                                          , liveStatus = Api.YoutubeModel.Unknown
                                          , statsOnConclusion = Nothing
                                          , statsAfter24Hours = Nothing
                                          , reportAfter24Hours = Nothing
                                          , liveChatId = Nothing
                                          , chatMsgCount = Nothing
                                          }
                                        )
                                    )
                                |> Dict.fromList

                        -- here we get all the videos we don't have in the model yet
                        newVideos =
                            MoreDict.leftDiff retrievedVideos model.videos

                        videosToPersist =
                            Dict.union newVideos model.videos

                        newModel =
                            { model
                                | videos = videosToPersist
                            }

                        fetchMore =
                            Maybe.map2
                                (\nextPageToken accessToken_ ->
                                    YouTubeApi.getVideosCmd (Just nextPageToken) playlistId accessToken_
                                )
                                validResponse.nextPageToken
                                (video_getAccesToken newModel playlistId)
                                |> Maybe.withDefault Cmd.none
                    in
                    ( newModel
                    , fetchMore
                    )

                Err error ->
                    ( model
                    , Cmd.none
                    )
                        |> log ("Failed to fetch videos for playlist : " ++ playlistId ++ "\n" ++ httpErrToString error) Error

        Batch_GetLiveVideoStreamData time ->
            let
                -- check all the videos that we know are live or scheduled or we don't know yet
                ( liveOrScheduledVideos, oldLiveOrScheduledVideos ) =
                    model.videos
                        |> Dict.filter
                            (\_ v ->
                                case v.liveStatus of
                                    Api.YoutubeModel.Unknown ->
                                        True

                                    Api.YoutubeModel.Live ->
                                        True

                                    Api.YoutubeModel.Scheduled _ ->
                                        True

                                    _ ->
                                        False
                            )
                        |> Dict.partition (\_ v -> video_isNew v)

                -- get their live data
                fetches =
                    liveOrScheduledVideos
                        |> Dict.map
                            (\_ v ->
                                video_getAccesToken model v.id
                                    |> Maybe.map (YouTubeApi.getVideoLiveStreamDataCmd time v.id)
                            )
                        |> Dict.values
                        |> fnLog "fetches" List.length
                        |> List.filterMap identity

                -- this updates the videos to old so that we know why they didn't update
                newVideos =
                    oldLiveOrScheduledVideos
                        |> Dict.map (\_ v -> { v | liveStatus = Api.YoutubeModel.Old })

                newModel =
                    { model
                        | videos = Dict.union newVideos model.videos
                    }
            in
            ( newModel
            , fetches |> Cmd.batch
            )

        GotLiveVideoStreamData timestamp videoId liveVideoResponseData ->
            -- assumption -> there's only one item in the .items
            case liveVideoResponseData of
                Ok liveVideoResponse ->
                    let
                        liveStreamingDetails =
                            liveVideoResponse.items
                                |> List.head
                                |> Maybe.andThen .liveStreamingDetails

                        wasNeverLive =
                            liveStreamingDetails == Nothing

                        isScheduled =
                            liveStreamingDetails
                                |> Maybe.map (\l -> l.actualStartTime == Nothing)
                                |> Maybe.withDefault False

                        whenScheduledStr =
                            liveStreamingDetails
                                |> Maybe.andThen .scheduledStartTime
                                |> Maybe.withDefault "strange error"

                        whenEndedStr =
                            liveStreamingDetails
                                |> Maybe.andThen .actualEndTime
                                |> Maybe.withDefault "strange error"

                        whenScheduled =
                            whenScheduledStr
                                |> Iso8601.toTime

                        isLive =
                            liveStreamingDetails
                                |> Maybe.map (\l -> l.actualStartTime /= Nothing && l.actualEndTime == Nothing)
                                |> Maybe.withDefault False

                        wasLive =
                            liveStreamingDetails
                                |> Maybe.map (\l -> l.actualEndTime /= Nothing)
                                |> Maybe.withDefault False

                        newVideo =
                            model.videos
                                |> Dict.get videoId
                                |> Maybe.map
                                    (\currentVideoRecord ->
                                        case ( wasNeverLive, isScheduled, ( isLive, wasLive, whenScheduled ) ) of
                                            ( True, _, ( _, _, _ ) ) ->
                                                { currentVideoRecord | liveStatus = Api.YoutubeModel.NeverLive }

                                            ( _, True, ( _, _, Ok whenScheduled_ ) ) ->
                                                -- if the scheduled time is more than 150 minutes ago, then we stop monitoring it
                                                if (timestamp |> Time.posixToMillis) - (whenScheduled_ |> Time.posixToMillis) < (150 * minute) then
                                                    { currentVideoRecord | liveStatus = Api.YoutubeModel.Scheduled whenScheduledStr }

                                                else
                                                    { currentVideoRecord | liveStatus = Api.YoutubeModel.Expired }

                                            ( _, _, ( True, _, _ ) ) ->
                                                { currentVideoRecord | liveStatus = Api.YoutubeModel.Live }

                                            ( _, _, ( _, True, _ ) ) ->
                                                { currentVideoRecord | liveStatus = Api.YoutubeModel.Ended whenEndedStr }

                                            _ ->
                                                { currentVideoRecord | liveStatus = Api.YoutubeModel.Impossibru }
                                    )

                        activeLiveChatId =
                            liveStreamingDetails
                                |> Maybe.andThen .activeLiveChatId

                        newVideos =
                            case newVideo of
                                Just newVideo_ ->
                                    model.videos |> Dict.insert videoId { newVideo_ | liveChatId = activeLiveChatId }

                                Nothing ->
                                    model.videos

                        currentViewers : Maybe Api.YoutubeModel.CurrentViewers
                        currentViewers =
                            liveStreamingDetails
                                |> Maybe.andThen .concurrentViewers
                                |> Maybe.andThen String.toInt
                                |> Maybe.map
                                    (\cv ->
                                        { videoId = videoId
                                        , value = cv
                                        , timestamp = timestamp
                                        }
                                    )

                        newCurrentViewers =
                            case currentViewers of
                                Just currentViewers_ ->
                                    model.currentViewers |> Dict.insert ( videoId, timestamp |> Time.posixToMillis ) currentViewers_

                                Nothing ->
                                    model.currentViewers

                        newLiveVideoDetails =
                            case liveStreamingDetails of
                                Just liveStreamingDetails_ ->
                                    let
                                        newLiveVideoDetails_ =
                                            { videoId = videoId
                                            , scheduledStartTime =
                                                liveStreamingDetails_.scheduledStartTime
                                                    |> Maybe.withDefault "1970-01-01T00:00:00+00:00Z"
                                            , actualStartTime = liveStreamingDetails_.actualStartTime
                                            , actualEndTime = liveStreamingDetails_.actualEndTime
                                            }
                                    in
                                    model.liveVideoDetails |> Dict.insert videoId newLiveVideoDetails_

                                Nothing ->
                                    model.liveVideoDetails

                        newModel =
                            { model
                                | videos = newVideos
                                , currentViewers = newCurrentViewers
                                , liveVideoDetails = newLiveVideoDetails
                            }
                    in
                    ( newModel
                    , Cmd.none
                    )
                        |> log ("Got live video stream data for video : " ++ videoId) Info

                Err error ->
                    ( model
                    , Cmd.none
                    )
                        |> log ("Failed to fetch live video data for video : " ++ videoId ++ "\n" ++ httpErrToString error) Error

        Batch_GetVideoStats time ->
            let
                -- fetch the stats for all the videos that have concluded, but don't have stats yet
                -- fetch the stats for all videos that have conclusion stats, but don't have 24hr stats yet
                concludedVideosWithNoStats =
                    model.videos
                        |> Dict.filter
                            (\_ v ->
                                case ( v.liveStatus, v.statsAfter24Hours ) of
                                    ( Api.YoutubeModel.Ended _, Nothing ) ->
                                        True

                                    _ ->
                                        False
                            )
                        |> Dict.filter (\_ v -> video_isNew v)

                fetchConcluded =
                    concludedVideosWithNoStats
                        |> Dict.keys
                        |> List.map
                            (\videoId ->
                                video_getAccesToken model videoId
                                    |> Maybe.map (YouTubeApi.getVideoStatsOnConclusionCmd time videoId)
                            )
                        |> List.filterMap identity

                concludedVideosThatNeed24HrStats =
                    model.videos
                        |> Dict.filter
                            (\_ v ->
                                case ( v.liveStatus, v.statsAfter24Hours ) of
                                    ( Api.YoutubeModel.Ended endTimeStr, Just _ ) ->
                                        let
                                            endTime =
                                                endTimeStr |> Iso8601.toTime |> Result.map Time.posixToMillis |> Result.withDefault 0

                                            now =
                                                time |> Time.posixToMillis
                                        in
                                        (now - endTime) >= (24 * hour)

                                    _ ->
                                        False
                            )
                        |> Dict.filter (\_ v -> video_isNew v)

                fetch24HrStats =
                    concludedVideosThatNeed24HrStats
                        |> Dict.keys
                        |> List.map
                            (\videoId ->
                                video_getAccesToken model videoId
                                    |> Maybe.map (YouTubeApi.getVideoStatsAfter24HrsCmd time videoId)
                            )
                        |> List.filterMap identity
            in
            ( model
            , Cmd.batch (fetchConcluded ++ fetch24HrStats)
            )

        GotVideoStatsOnConclusion time videoId videoWithStatsResponse ->
            case videoWithStatsResponse of
                Ok videoWithStats ->
                    let
                        retrievedStats =
                            videoWithStats.items |> List.head |> Maybe.andThen .statistics

                        newVideo =
                            model.videos
                                |> Dict.get videoId
                                |> Maybe.map
                                    (\currentVideoRecord ->
                                        case retrievedStats of
                                            Just retrievedStats_ ->
                                                { currentVideoRecord | statsOnConclusion = Just retrievedStats_ }

                                            Nothing ->
                                                { currentVideoRecord | statsOnConclusion = Nothing }
                                    )

                        newVideos =
                            case newVideo of
                                Just newVideo_ ->
                                    model.videos |> Dict.insert videoId newVideo_

                                Nothing ->
                                    model.videos

                        newModel =
                            { model
                                | videos = newVideos
                            }
                    in
                    ( newModel, Cmd.none )

                Err error ->
                    ( model, Cmd.none )
                        |> log ("Failed to fetch stats on conclusion for video : " ++ videoId ++ "\n" ++ httpErrToString error) Error

        GotVideoStatsAfter24Hrs time videoId videoWithStatsResponse ->
            case videoWithStatsResponse of
                Ok videoWithStats ->
                    let
                        retrievedStats =
                            videoWithStats.items |> List.head |> Maybe.andThen .statistics

                        newVideo =
                            model.videos
                                |> Dict.get videoId
                                |> Maybe.map
                                    (\currentVideoRecord ->
                                        case retrievedStats of
                                            Just retrievedStats_ ->
                                                { currentVideoRecord | statsAfter24Hours = Just retrievedStats_ }

                                            Nothing ->
                                                { currentVideoRecord | statsAfter24Hours = Nothing }
                                    )

                        newVideos =
                            case newVideo of
                                Just newVideo_ ->
                                    model.videos |> Dict.insert videoId newVideo_

                                Nothing ->
                                    model.videos

                        newModel =
                            { model
                                | videos = newVideos
                            }
                    in
                    ( newModel, Cmd.none )

                Err error ->
                    ( model, Cmd.none )
                        |> log ("Failed to fetch stats after 24 hours for video : " ++ videoId ++ "\n" ++ httpErrToString error) Error

        Batch_GetChatMessages time ->
            let
                -- immediately when a video has concluded, we fetch the chat messages, the chat message value is only available for a few minutes after it ends
                concludedVideosWithNoChatMsgCount =
                    model.videos
                        |> Dict.filter
                            (\_ v ->
                                case ( v.liveStatus, v.chatMsgCount, v.liveChatId ) of
                                    ( Api.YoutubeModel.Ended _, Nothing, Just _ ) ->
                                        True

                                    _ ->
                                        False
                            )

                fetches =
                    concludedVideosWithNoChatMsgCount
                        |> Dict.map
                            (\videoId v ->
                                Maybe.map2
                                    (YouTubeApi.getChatMessagesCmd Nothing)
                                    (video_getAccesToken model videoId)
                                    v.liveChatId
                            )
                        |> Dict.values
                        |> List.filterMap identity
            in
            ( model, Cmd.batch fetches )

        GotChatMessages liveChatId liveChatMsgResponse ->
            case liveChatMsgResponse of
                Ok liveChatMsgs ->
                    let
                        retreivedMsgCount =
                            liveChatMsgs.items |> List.length

                        videoToUpdate =
                            model.videos
                                |> Dict.filter (\_ v -> v.liveChatId == Just liveChatId)
                                |> Dict.values
                                |> List.head

                        newVideo : Maybe Api.YoutubeModel.Video
                        newVideo =
                            videoToUpdate
                                |> Maybe.map
                                    (\videoToUpdate_ ->
                                        { videoToUpdate_
                                            | chatMsgCount =
                                                videoToUpdate_.chatMsgCount
                                                    |> Maybe.map (\c -> c + retreivedMsgCount)
                                        }
                                    )

                        newModel =
                            newVideo
                                |> Maybe.map
                                    (\v ->
                                        { model | videos = Dict.insert v.id v model.videos }
                                    )
                                |> Maybe.withDefault model

                        accessToken =
                            newVideo
                                |> Maybe.andThen (\v -> video_getAccesToken model v.id)

                        fetchMore =
                            Maybe.map2
                                (\nextPageToken accessToken_ ->
                                    YouTubeApi.getChatMessagesCmd (Just nextPageToken) liveChatId accessToken_
                                )
                                liveChatMsgs.nextPageToken
                                accessToken
                                |> Maybe.withDefault Cmd.none
                    in
                    ( newModel, fetchMore )

                Err error ->
                    ( model, Cmd.none )
                        |> log ("Failed to fetch chat messages for live chat id : " ++ liveChatId ++ "\n" ++ httpErrToString error) Error

        Batch_GetVideoDailyReports time ->
            let
                -- note this implies that only videos that were live and were picked up by the app will be tracked.
                videosWithout24HrReport : Dict.Dict String Api.YoutubeModel.Video
                videosWithout24HrReport =
                    model.videos
                        |> Dict.filter
                            (\_ v ->
                                case ( v.liveStatus, v.reportAfter24Hours ) of
                                    ( Api.YoutubeModel.Ended endDateStr, Nothing ) ->
                                        ((endDateStr |> strToIntTime) + day) <= (time |> Time.posixToMillis)

                                    _ ->
                                        False
                            )
                        |> Dict.filter (\_ v -> video_isNew v)

                fetches =
                    videosWithout24HrReport
                        |> Dict.map
                            (\videoId v ->
                                case v.liveStatus of
                                    Api.YoutubeModel.Ended endDateStr ->
                                        Maybe.map3
                                            YouTubeApi.getVideoDailyReportCmd
                                            (Just videoId)
                                            (Just endDateStr)
                                            (video_getAccesToken model videoId)

                                    _ ->
                                        Nothing
                            )
                        |> Dict.values
                        |> List.filterMap identity
            in
            ( model, Cmd.batch fetches )

        GotVideoDailyReport videoId reportResponse ->
            case reportResponse of
                Ok report ->
                    let
                        -- type alias Report =
                        --     { averageViewPercentage : Float
                        --     , subscribersGained : Int
                        --     , subscribersLost : Int
                        --     }
                        newModel =
                            model.videos
                                |> Dict.get videoId
                                -- returns maybe an adjusted video record if the videoid is found
                                |> Maybe.map
                                    (\currentVideoRecord ->
                                        { currentVideoRecord
                                            | reportAfter24Hours =
                                                Just
                                                    { averageViewPercentage = report.averageViewPercentage
                                                    , subscribersGained = report.subscribersGained
                                                    , subscribersLost = report.subscribersLost
                                                    , views = report.views
                                                    }
                                        }
                                    )
                                --replaces it in the set of videos
                                |> Maybe.map (\newVideo_ -> model.videos |> Dict.insert videoId newVideo_)
                                -- replaces the set of videos in the model
                                |> Maybe.map (\newVideos -> { model | videos = newVideos })
                                -- returns the current model if the maybe is nothing
                                |> Maybe.withDefault model
                    in
                    ( newModel, Cmd.none )

                Err error ->
                    ( model, Cmd.none )
                        |> log ("Failed to fetch daily report for video : " ++ videoId ++ "\n" ++ httpErrToString error) Error

        Batch_GetVideoStatisticsAtTime time ->
            -- for the first 24 hours after a video ends, we fetch the stats every hour
            -- store these stats in the model.videoStatisticsAtTime
            let
                videosThatConcludedInPast24Hrs =
                    model.videos
                        |> Dict.filter
                            (\_ v ->
                                case v.liveStatus of
                                    Api.YoutubeModel.Ended endTime ->
                                        (endTime |> strToIntTime) + day >= (time |> Time.posixToMillis)

                                    _ ->
                                        False
                            )
                        |> Dict.filter (\_ v -> video_isNew v)

                videosWithNoStatsInPastHour =
                    model.videoStatisticsAtTime
                        |> Dict.filter (\_ s -> Dict.member s.videoId videosThatConcludedInPast24Hrs)
                        |> Dict.values
                        |> List.Extra.groupWhile (\a b -> a.videoId == b.videoId)
                        |> List.map (\( g, l ) -> l |> List.sortBy (.timestamp >> Time.posixToMillis) |> List.reverse |> List.head)
                        |> List.filterMap identity
                        |> List.filter (\s -> (s.timestamp |> Time.posixToMillis) + hour <= (time |> Time.posixToMillis))
                        |> List.map .videoId

                videosWithNoStatsAtAll =
                    model.videos 
                        |> Dict.filter (\_ v -> video_isNew v)
                        |> Dict.keys
                        |> List.filter (\videoId -> 
                            model.videoStatisticsAtTime
                                |> Dict.keys
                                |> List.map Tuple.first
                                |> List.member videoId
                                |> not
                        )

                videosToFetch =
                    videosWithNoStatsInPastHour ++ videosWithNoStatsAtAll
                    |> List.Extra.unique
                    --|> fnLog "videosToFetch" List.length

                fetches =
                    videosToFetch
                        |> List.map
                            (\videoId ->
                                video_getAccesToken model videoId
                                    |> Maybe.map (YouTubeApi.getVideoStats time videoId GotVideoStatsOnTheHour)
                            )
                        |> List.filterMap identity
                        |> fnLog "videosToFetch" List.length
                        -- |> List.take 1
            in
            ( model, Cmd.batch fetches )

        GotVideoStatsOnTheHour time videoId statsResponse ->
            case statsResponse of
                Ok statsResponse_ ->
                    let
                        _ = Debug.log "statsResponse__" statsResponse_

                        retrievedStats =
                            statsResponse_.items |> List.head |> Maybe.map .statistics
                            --|> Debug.log "retrievedStats"

                        -- type alias VideoStatisticsAtTime =
                        --     { videoId : String
                        --     , timestamp : Posix
                        --     , viewCount : Int
                        --     , likeCount : Int
                        --     , dislikeCount : Int
                        --     , favoriteCount : Int
                        --     , commentCount : Int
                        --     }
                        newModel =
                            retrievedStats
                                |> Maybe.map
                                    (\retrievedStats_ ->
                                        { videoId = videoId
                                        , timestamp = time
                                        , viewCount = retrievedStats_.viewCount |> String.toInt |> Maybe.withDefault 0
                                        , likeCount = retrievedStats_.likeCount |> String.toInt |> Maybe.withDefault 0
                                        , dislikeCount = retrievedStats_.dislikeCount |> Maybe.andThen String.toInt
                                        , favoriteCount = retrievedStats_.favoriteCount |> Maybe.andThen String.toInt 
                                        , commentCount = retrievedStats_.commentCount |> Maybe.andThen String.toInt
                                        }
                                    )
                                |> Maybe.map
                                    (\newStats ->
                                        { model
                                            | videoStatisticsAtTime = Dict.insert ( videoId, time |> Time.posixToMillis ) newStats model.videoStatisticsAtTime
                                        }
                                    )
                                |> Maybe.withDefault model
                                --|> Debug.log "newModel" 
                    in
                    ( newModel, Cmd.none )

                Err error ->
                    let
                        _ =
                            Debug.log "GotVideoStatsOnTheHour error" error
                    in
                    ( model, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        AttemptSignOut ->
            ( { model | authenticatedSessions = model.authenticatedSessions |> Dict.remove sessionId }
            , sendToShared clientId <| SignOutUser
            )

        AttemptSignIn user ->
            case model.users |> Dict.get user.email of
                Just existingUser ->
                    let
                        passwordHash =
                            hashPassword user.password existingUser.salt
                    in
                    if passwordHash == existingUser.passwordHash then
                        ( model
                        , Cmd.batch
                            [ sendToPage clientId <|
                                Gen.Msg.Login <|
                                    Pages.Login.GotUser <|
                                        Api.Data.Success <|
                                            Api.User.toUser existingUser
                            , performNowWithTime (AuthenticateSession sessionId clientId <| Api.User.toUser existingUser)
                            ]
                        )

                    else
                        ( model
                        , sendToPage clientId <|
                            Gen.Msg.Login <|
                                Pages.Login.GotUser <|
                                    Api.Data.Failure "Incorrect email or password."
                        )

                Nothing ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Login <|
                            Pages.Login.GotUser <|
                                Api.Data.Failure "Incorrect email or password."
                    )

        AttemptRegistration user ->
            let
                ( validEmail, validPass ) =
                    Api.User.validateUser user
            in
            case ( validEmail, validPass ) of
                ( True, True ) ->
                    case model.users |> Dict.get user.email of
                        Just _ ->
                            ( model
                            , sendToPage clientId <|
                                Gen.Msg.Register <|
                                    Pages.Register.GotUser <|
                                        Api.Data.Failure "This email address is already taken"
                            )

                        Nothing ->
                            ( model
                            , Random.generate (RegisterUser sessionId clientId user) randomSalt
                            )

                ( False, _ ) ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Register <|
                            Pages.Register.GotUser <|
                                Api.Data.Failure "Please enter a valid email address"
                    )

                ( _, False ) ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Register <|
                            Pages.Register.GotUser <|
                                Api.Data.Failure "Please enter a valid password"
                    )

        NoOpToBackend ->
            ( model, Cmd.none )

        AttemptGetCredentials ->
            let
                userEmail =
                    model.authenticatedSessions |> Dict.get sessionId |> Maybe.map .user

                adminEmails =
                    Env.adminUsers |> String.split ","

                isAdmin =
                    case userEmail of
                        Just userEmail_ ->
                            List.member userEmail_ adminEmails

                        Nothing ->
                            False

                santizedCredentials =
                    if isAdmin then
                        model.clientCredentials

                    else
                        model.clientCredentials
                            |> Dict.map (\_ v -> { v | accessToken = "", refreshToken = "" })
            in
            ( model
            , sendToPage clientId <|
                Gen.Msg.Example <|
                    Pages.Example.GotCredentials <|
                        santizedCredentials
            )

        AttemptGetChannels email ->
            let
                channelAssociations =
                    model.channelAssociations
                        |> List.filter (\c -> c.email == email)
                        |> List.map .channelId

                channels =
                    model.channels
                        |> Dict.filter (\k _ -> List.member k channelAssociations)
                        |> Dict.values
            in
            ( model
            , sendToPage clientId <|
                Gen.Msg.Ga__Email_ <|
                    Pages.Ga.Email_.GotChannels <|
                        channels
            )

        AttemptGetChannelAndPlaylists channelId ->
            let
                channel =
                    model.channels
                        |> Dict.get channelId

                playlists =
                    model.playlists
                        |> Dict.filter (\_ v -> v.channelId == channelId)

                schedules =
                    model.schedules
                        |> Dict.filter (\_ v -> playlists |> Dict.member v.playlistId)
            in
            case channel of
                Just channel_ ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Channel__Id_ <|
                            Pages.Channel.Id_.GotChannelAndPlaylists channel_ playlists schedules
                    )
                        |> log ("Found channel with id: " ++ channelId ++ " Playlists retrieved = " ++ (playlists |> Dict.size |> String.fromInt)) Info

                Nothing ->
                    ( model, Cmd.none ) |> log ("Failed to find channel with id: " ++ channelId) Error

        AttemptGetLogs ->
            ( model
            , sendToPage clientId <|
                Gen.Msg.Log <|
                    Pages.Log.GotLogs <|
                        model.logs
            )

        FetchChannelsFromYoutube email ->
            ( model, performNow (GetChannelsByCredential email) )

        FetchPlaylistsFromYoutube channelId ->
            ( model, performNow (GetPlaylistsByChannel channelId) )

        FetchVideosFromYoutube playlistId ->
            ( model, performNow (GetVideosByPlaylist Nothing playlistId) )

        UpdateSchedule schedule ->
            ( { model | schedules = model.schedules |> Dict.insert schedule.playlistId schedule }
            , Cmd.none
            )

        UpdatePlaylist playlist ->
            ( { model | playlists = model.playlists |> Dict.insert playlist.id playlist }
            , Cmd.none
            )

        AttemptGetVideos playlistId ->
            let
                playlists =
                    case playlistId of
                        "*" ->
                            model.playlists
                                |> Dict.filter (\_ v -> v.monitor)

                        playlistId_ ->
                            model.playlists
                                |> Dict.filter (\_ v -> v.id == playlistId_)

                videos =
                    model.videos
                        |> Dict.filter (\_ v -> v.playlistId == playlistId || (playlistId == "*" && Dict.member v.playlistId playlists))

                liveVideoDetails =
                    model.liveVideoDetails
                        |> Dict.filter (\_ v -> Dict.member v.videoId videos)

                currentViewers =
                    model.currentViewers
                        |> Dict.filter (\( videoId, _ ) _ -> Dict.member videoId videos)

                videoChannels =
                    model.videos
                        |> Dict.map
                            (\_ v ->
                                model.channels
                                    |> Dict.get v.channelId
                                    |> Maybe.map .title
                                    |> Maybe.withDefault "Unknown"
                            )
            in
            ( model
            , sendToPage clientId <|
                Gen.Msg.Playlist__Id_ <|
                    Pages.Playlist.Id_.GotVideos playlists videos liveVideoDetails currentViewers videoChannels
            )


randomSalt : Random.Generator String
randomSalt =
    Random.String.string 10 Random.Char.english


randomIdFromTime int time =
    (int |> fromInt) ++ "-" ++ (time |> Time.posixToMillis |> fromInt) |> Crypto.Hash.sha224 |> String.left 12


hashPassword password salt =
    Crypto.Hash.sha256 <| password ++ salt



-- HELPERS


isAdminSession : Model -> SessionId -> Bool
isAdminSession model sessionId =
    let
        maybeUser =
            model.authenticatedSessions
                |> Dict.get sessionId
                |> Maybe.map .user
                |> Maybe.andThen (\user -> model.users |> Dict.get user)
    in
    case maybeUser of
        Nothing ->
            False

        Just user ->
            user.role == Api.User.Admin


isAuthorised : Api.User.RequiredRole -> Model -> Time.Posix -> SessionId -> Bool
isAuthorised requiredRole model now sessionId =
    let
        maybeUserRole =
            model.authenticatedSessions
                |> Dict.get sessionId
                |> Maybe.andThen
                    (\session ->
                        if session |> not << hasExpired now then
                            model.users |> Dict.get session.user

                        else
                            Nothing
                    )
                |> Maybe.map (\user -> user.role)
    in
    case maybeUserRole of
        Just userRole ->
            userRole |> Api.User.checkAuthorization requiredRole

        Nothing ->
            False


sendToPage clientId page =
    sendToFrontend clientId <| PageMsg <| page


sendToShared clientId msg =
    sendToFrontend clientId <| SharedMsg <| msg


httpErrToString : Error -> String
httpErrToString error =
    "HTTP Error - "
        ++ (case error of
                BadUrl url ->
                    "Bad URL: " ++ url

                Timeout ->
                    "Timeout occurred"

                NetworkError ->
                    "Network error occurred"

                BadStatus statusCode ->
                    "Bad status code: " ++ String.fromInt statusCode

                BadBody message ->
                    "Bad body: " ++ message
           )


playlist_latestVideo model playlistId =
    model.videos
        |> Dict.values
        |> List.filter (\v -> v.playlistId == playlistId)
        |> List.sortBy (\v -> v.publishedAt)
        |> List.reverse
        |> List.head



-- gets us the most up to date video we've fetched from youtube so we don't have to fetch videos after this points


playlist_lastPublishDate model playlistId =
    model.videos
        |> playlist_latestVideo playlistId
        |> Maybe.map .publishedAt
        |> Maybe.withDefault "1970-01-01T00:00:00Z"


video_getAccesToken model videoId =
    model.videos
        |> Dict.get videoId
        |> Maybe.map .channelId
        |> Maybe.andThen
            (\channelId ->
                model.channelAssociations
                    |> List.filter (\c -> c.channelId == channelId)
                    |> List.head
                    |> Maybe.map .email
            )
        |> Maybe.andThen
            (\email ->
                model.clientCredentials
                    |> Dict.get email
                    |> Maybe.map .accessToken
            )


video_isNew v =
    let
        pulishedTimeInt =
            v.publishedAt |> strToIntTime

        cuttoffTimeInt =
            "2024-01-01T00:00:00Z" |> strToIntTime
    in
    pulishedTimeInt >= cuttoffTimeInt 


fnLog msg fn thing =
    let
        _ =
            thing
                |> fn
                |> Debug.log msg
    in
    thing
