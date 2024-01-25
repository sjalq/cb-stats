module Backend exposing (..)

import Api.Data
import Api.Logging as Logging exposing (..)
import Api.PerformNow exposing (performNow, performNowWithTime)
import Api.User
import Api.YoutubeModel exposing (..)
import BackendLogging exposing (log)
import Bridge exposing (..)
import Crypto.Hash
import Dict
import Dict.Extra as Dict
import Env
import Gen.Msg
import GoogleSheetsApi
import Html.Attributes exposing (property)
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
import Pages.Video.Id_
import Random
import Random.Char
import Random.String
import Set
import Shared exposing (Msg(..))
import String exposing (fromInt)
import Task
import Time
import Time.Extra as Time
import Types exposing (BackendModel, BackendMsg(..), FrontendMsg(..), NextAction(..), ToFrontend(..), hasExpired)
import Utils.Time exposing (..)
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
      , competitors = Set.empty
      , schedules = Dict.empty
      , videos = Dict.empty
      , videoStatisticsAtTime = Dict.empty
      , liveVideoDetails = Dict.empty
      , currentViewers = Dict.empty
      , channelHandleMap = []
      , apiCallCount = 0
      , time = Time.millisToPosix 0
      }
    , Cmd.none
    )


pollingInterval =
    case Env.mode of
        Env.Development ->
            60 * minute

        Env.Production ->
            15 * minute


subscriptions : Model -> Sub BackendMsg
subscriptions model =
    Sub.batch
        [ Time.every (10 * second) Tick
        , Time.every (10 * second) Batch_RefreshAccessTokens
        , Time.every hour Batch_RefreshAllChannels
        , Time.every hour Batch_RefreshAllPlaylists
        , Time.every pollingInterval Batch_RefreshAllVideosFromPlaylists
        , Time.every (15 * second) Batch_GetLiveVideoStreamData
        , Time.every minute Batch_GetVideoStats
        , Time.every hour Batch_GetVideoDailyReports
        , Time.every (8 * hour) Batch_GetCompetitorChannelIds
        , Time.every (8 * hour) Batch_GetCompetitorVideos

        --, Time.every (10 * second) Batch_GetChatMessages
        , Time.every (10 * minute) Batch_GetVideoStatisticsAtTime
        , Time.every (10 * minute) Batch_ExportToSheet
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
                                          , competitorHandles = Set.empty
                                          , competitorIds = Set.empty
                                          }
                                        )
                                    )
                                |> Dict.fromList

                        newPlaylists =
                            MoreDict.fullOuterJoin retrievedPlaylists model.playlists
                                |> MoreDict.filterMapJoin
                                    identity
                                    identity
                                    (\( retrieved, current ) ->
                                        { retrieved
                                            | monitor = current.monitor
                                            , competitorHandles = current.competitorHandles
                                            , competitorIds = current.competitorIds
                                        }
                                    )

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
                        retrievedVideos : Dict.Dict String Api.YoutubeModel.Video
                        retrievedVideos =
                            validResponse.items
                                |> List.map
                                    (\v ->
                                        ( v.snippet.resourceId.videoId
                                        , { id = v.snippet.resourceId.videoId
                                          , title = v.snippet.title
                                          , description = v.snippet.description
                                          , videoOwnerChannelId = v.snippet.videoOwnerChannelId |> Maybe.withDefault ""
                                          , videoOwnerChannelTitle = v.snippet.videoOwnerChannelTitle |> Maybe.withDefault ""
                                          , playlistId = v.snippet.playlistId
                                          , thumbnailUrl = v.snippet.thumbnails |> Maybe.map (.standard >> .url)
                                          , publishedAt = v.snippet.publishedAt
                                          , liveStatus = Api.YoutubeModel.Unknown
                                          , statsOnConclusion = Nothing
                                          , statsAfter24Hours = Nothing
                                          , reportAfter24Hours = Nothing
                                          , liveChatId = Nothing
                                          , chatMsgCount = Nothing
                                          , ctr = Nothing
                                          , liveViews = Nothing
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
                                (video_getAccessToken newModel playlistId)
                                |> Maybe.withDefault Cmd.none
                    in
                    ( newModel
                    , Cmd.none
                      -- todo: @Schalk, figure this out, you removed it to prevent fetching pages and pages of
                      -- playlist items
                      --fetchMore
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

                                    Api.YoutubeModel.Scheduled scheduledTimeStr ->
                                        -- we offset this by 2 minutes to allow for the the timer to pick up that it is live
                                        -- and to allow for the fact that the timer in which this runs might not
                                        -- trigger on the exact scheduled time
                                        (scheduledTimeStr |> strToIntTime) - (2 * minute) <= (time |> Time.posixToMillis)

                                    _ ->
                                        False
                            )
                        |> Dict.partition (\_ v -> video_isNew v)

                -- get their live data
                fetches =
                    liveOrScheduledVideos
                        |> Dict.map
                            (\_ v ->
                                video_getAccessToken model v.id
                                    |> Maybe.map (YouTubeApi.getVideoLiveStreamDataCmd time v.id)
                            )
                        |> Dict.values
                        |> List.filterMap identity

                -- this updates the videos to old so that we know why they didn't update
                updatedVideoList =
                    oldLiveOrScheduledVideos
                        |> Dict.map (\_ v -> { v | liveStatus = Api.YoutubeModel.Old })

                newModel =
                    { model
                        | videos = Dict.union updatedVideoList model.videos
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
                                        case ( wasNeverLive, isLive, ( isScheduled, wasLive, whenScheduled ) ) of
                                            ( True, _, ( _, _, _ ) ) ->
                                                { currentVideoRecord | liveStatus = Api.YoutubeModel.Uploaded }

                                            ( _, True, ( _, _, _ ) ) ->
                                                { currentVideoRecord | liveStatus = Api.YoutubeModel.Live }

                                            ( _, _, ( True, _, Ok whenScheduled_ ) ) ->
                                                -- if the scheduled time is more than 35 minutes ago, then we stop monitoring it
                                                if (timestamp |> Time.posixToMillis) - (whenScheduled_ |> Time.posixToMillis) < (35 * minute) then
                                                    { currentVideoRecord | liveStatus = Api.YoutubeModel.Scheduled whenScheduledStr }

                                                else
                                                    { currentVideoRecord | liveStatus = Api.YoutubeModel.Expired }

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

                Err error ->
                    ( model
                    , Cmd.none
                    )

        Batch_GetVideoStats time ->
            let
                -- fetch the stats for all the videos that have concluded, but don't have stats yet
                -- fetch the stats for all videos that have conclusion stats, but don't have 24hr stats yet
                concludedVideosWithNoStats =
                    model.videos
                        |> Dict.filter
                            (\_ v ->
                                case ( v.liveStatus, v.statsOnConclusion ) of
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
                                video_getAccessToken model videoId
                                    |> Maybe.map (YouTubeApi.getVideoStats time videoId GotVideoStatsOnConclusion)
                            )
                        |> List.filterMap identity

                concludedVideosThatNeed24HrStats =
                    model.videos
                        |> Dict.filter
                            (\_ v ->
                                case ( v.liveStatus, v.statsAfter24Hours ) of
                                    ( Api.YoutubeModel.Ended endTimeStr, Nothing ) ->
                                        let
                                            endTime =
                                                endTimeStr
                                                    |> Iso8601.toTime
                                                    |> Result.map Time.posixToMillis
                                                    |> Result.withDefault 0

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
                                video_getAccessToken model videoId
                                    |> Maybe.map (YouTubeApi.getVideoStats time videoId GotVideoStatsAfter24Hrs)
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
                            videoWithStats.items |> List.head |> Maybe.map .statistics

                        newVideo =
                            model.videos
                                |> Dict.get videoId
                                |> Maybe.map
                                    (\currentVideoRecord ->
                                        case retrievedStats of
                                            Just retrievedStats_ ->
                                                { currentVideoRecord
                                                    | statsOnConclusion =
                                                        Just
                                                            { commentCount = retrievedStats_.commentCount |> Maybe.andThen String.toInt |> Maybe.withDefault 0
                                                            , dislikeCount = retrievedStats_.dislikeCount |> Maybe.andThen String.toInt
                                                            , favoriteCount = retrievedStats_.favoriteCount |> Maybe.andThen String.toInt
                                                            , likeCount = retrievedStats_.likeCount |> String.toInt |> Maybe.withDefault 0
                                                            , viewCount = retrievedStats_.viewCount |> String.toInt |> Maybe.withDefault 0
                                                            }
                                                }

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

        GotVideoStatsAfter24Hrs time videoId videoWithStatsResponse ->
            case videoWithStatsResponse of
                Ok videoWithStats ->
                    let
                        retrievedStats =
                            videoWithStats.items |> List.head |> Maybe.map .statistics

                        newVideo =
                            model.videos
                                |> Dict.get videoId
                                |> Maybe.map
                                    (\currentVideoRecord ->
                                        case retrievedStats of
                                            Just retrievedStats_ ->
                                                { currentVideoRecord
                                                    | statsAfter24Hours =
                                                        Just
                                                            { commentCount = retrievedStats_.commentCount |> Maybe.andThen String.toInt |> Maybe.withDefault 0
                                                            , dislikeCount = retrievedStats_.dislikeCount |> Maybe.andThen String.toInt
                                                            , favoriteCount = retrievedStats_.favoriteCount |> Maybe.andThen String.toInt
                                                            , likeCount = retrievedStats_.likeCount |> String.toInt |> Maybe.withDefault 0
                                                            , viewCount = retrievedStats_.viewCount |> String.toInt |> Maybe.withDefault 0
                                                            }
                                                }

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
                                    (video_getAccessToken model videoId)
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
                                |> Maybe.andThen (\v -> video_getAccessToken model v.id)

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

        Batch_GetVideoDailyReports time ->
            let
                -- note this implies that only videos that were live and were picked up by the app will be tracked.
                videosWithout24HrReport : Dict.Dict String Api.YoutubeModel.Video
                videosWithout24HrReport =
                    model.videos
                        |> Dict.filter (\_ v -> video_isNew v)
                        |> Dict.filter
                            (\_ v ->
                                case ( v.publishedAt, v.liveStatus, v.reportAfter24Hours ) of
                                    ( _, Api.YoutubeModel.Ended endDateStr, Nothing ) ->
                                        ((endDateStr |> strToIntTime) + day) <= (time |> Time.posixToMillis)

                                    ( publishedAt, Api.YoutubeModel.Uploaded, Nothing ) ->
                                        ((publishedAt |> strToIntTime) + day) <= (time |> Time.posixToMillis)

                                    _ ->
                                        False
                            )

                fetches =
                    videosWithout24HrReport
                        |> Dict.map
                            (\videoId v ->
                                let
                                    checkDateStr =
                                        case v.liveStatus of
                                            Api.YoutubeModel.Ended endDateStr ->
                                                Just endDateStr

                                            Api.YoutubeModel.Uploaded ->
                                                Just v.publishedAt

                                            _ ->
                                                Nothing
                                in
                                Maybe.map3
                                    YouTubeApi.getVideoDailyReportCmd
                                    (Just videoId)
                                    checkDateStr
                                    (video_getAccessToken model videoId)
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

        Batch_GetVideoStatisticsAtTime time ->
            -- for the first 24 hours after a video ends, we fetch the stats every hour
            -- store these stats in the model.videoStatisticsAtTime
            let
                videosThatConcludedInPast24Hrs =
                    model.videos
                        |> Dict.filter
                            (\_ v ->
                                let
                                    checkTime =
                                        case ( v.liveStatus, v.publishedAt ) of
                                            ( Api.YoutubeModel.Ended endTime, _ ) ->
                                                endTime |> strToIntTime

                                            ( Api.YoutubeModel.Uploaded, publishedAt ) ->
                                                publishedAt |> strToIntTime

                                            _ ->
                                                0
                                in
                                checkTime + day >= (time |> Time.posixToMillis)
                            )
                        |> Dict.filter (\_ v -> video_isNew v)

                videosWithNoStatsInPastHour =
                    model.videoStatisticsAtTime
                        |> Dict.filter (\_ s -> Dict.member s.videoId videosThatConcludedInPast24Hrs)
                        |> Dict.values
                        |> groupByComparable (\s -> s.videoId)
                        |> List.map
                            (\( _, s ) ->
                                s
                                    |> List.sortBy (.timestamp >> Time.posixToMillis >> (*) -1)
                                    |> List.head
                            )
                        |> List.filterMap identity
                        |> List.filter (\s -> (s.timestamp |> Time.posixToMillis) + hour <= (time |> Time.posixToMillis))
                        |> List.map .videoId

                videosWithNoStatsAtAll =
                    videosThatConcludedInPast24Hrs
                        |> Dict.keys
                        |> List.filter
                            (\videoId ->
                                model.videoStatisticsAtTime
                                    |> Dict.keys
                                    |> List.map Tuple.first
                                    |> List.member videoId
                                    |> not
                            )

                videosToFetch =
                    videosWithNoStatsInPastHour
                        ++ videosWithNoStatsAtAll
                        |> List.Extra.unique

                fetches =
                    videosToFetch
                        |> List.map
                            (\videoId ->
                                video_getAccessToken model videoId
                                    |> Maybe.map (YouTubeApi.getVideoStats time videoId GotVideoStatsOnTheHour)
                            )
                        |> List.filterMap identity

                -- |> List.take 1
            in
            ( model, Cmd.batch fetches )

        GotVideoStatsOnTheHour time videoId statsResponse ->
            case statsResponse of
                Ok statsResponse_ ->
                    let
                        _ =
                            Debug.log "statsResponse__" statsResponse_

                        retrievedStats =
                            statsResponse_.items |> List.head |> Maybe.map .statistics

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
                    in
                    ( newModel, Cmd.none )

                Err error ->
                    ( model, Cmd.none )
                        |> log ("Failed to fetch stats on the hour for video : " ++ videoId ++ "\n" ++ httpErrToString error) Error

        Batch_GetCompetitorChannelIds time ->
            -- fetch the competitor channelId from https://yt.lemnoslife.com/channels?
            let
                competitorHandles =
                    model.playlists
                        |> Dict.values
                        |> List.map
                            (\p ->
                                p.competitorHandles
                                    |> Debug.log "competitorHandles"
                                    |> Set.toList
                                    |> List.filter
                                        (\handle ->
                                            (model.channelHandleMap
                                                |> List.filter (\( h, _ ) -> h == handle)
                                                |> List.length
                                            )
                                                == 0
                                        )
                                    |> List.map
                                        (\handle -> performNow <| GetChannelId handle)
                            )
                        |> List.concat
            in
            ( model, Cmd.batch competitorHandles )

        GetChannelId channelHandle ->
            ( model
            , YouTubeApi.getChannelIdCmd channelHandle
            )

        GotChannelId channelHandle channelIdResponse ->
            case channelIdResponse of
                Ok channelIdResponse_ ->
                    let
                        newModel =
                            channelIdResponse_.items
                                |> List.head
                                |> Maybe.map
                                    (\c ->
                                        { model
                                            | channelHandleMap =
                                                ( channelHandle, c.id )
                                                    :: model.channelHandleMap
                                                    |> List.Extra.unique
                                        }
                                    )
                                |> Maybe.withDefault model
                    in
                    ( newModel, Cmd.none )

                Err error ->
                    ( model, Cmd.none )
                        |> log ("Failed to fetch channel id for handle : " ++ channelHandle ++ "\n" ++ httpErrToString error) Error

        Batch_GetCompetitorVideos time ->
            let
                -- channelIdAccessToken : List ( String, String )
                -- channelIdAccessToken =
                --     model.channelHandleMap
                --         |> List.map
                --             (\( handle, channelId ) ->
                --                 competitorHandle_getAccessToken model handle
                --                     |> Maybe.map (\accessToken -> ( channelId, accessToken ))
                --             )
                --         |> Debug.log "channelIdAccessToken"
                --         |> List.filterMap identity
                channelIdAccessToken =
                    model.playlists
                        |> Dict.map
                            (\playlistId v ->
                                v.competitorIds
                                    |> Set.toList
                                    |> List.map (\id -> ( id, accessToken_getLatest model ))
                            )
                        |> Dict.values
                        |> List.concat
                        |> List.Extra.unique

                channelIdStr =
                    channelIdAccessToken
                        |> List.map Tuple.first
                        |> String.join ","

                fetches =
                    channelIdAccessToken
                        |> List.map
                            (\( channelId, accessToken ) ->
                                Cmd.batch
                                    [ YouTubeApi.getCompetitorLiveVideosCmd channelId accessToken time
                                    , YouTubeApi.getCompetitorOtherVideosCmd channelId accessToken time
                                    ]
                            )
                        |> Debug.log "fetches"
            in
            ( model, Cmd.batch fetches )
                |> log ("Fetching Competitor Videos - " ++ channelIdStr) Info

        GotCompetitorVideos channelId searchResponse ->
            case searchResponse of
                Ok searchResponse_ ->
                    let
                        newVideos =
                            searchResponse_.items
                                |> List.filter (\v -> model.videos |> Dict.member v.id.videoId |> not)
                                |> List.map
                                    (\v ->
                                        { id = v.id.videoId
                                        , title = v.snippet.title
                                        , description = v.snippet.description
                                        , videoOwnerChannelId = v.snippet.channelId
                                        , videoOwnerChannelTitle = v.snippet.channelTitle
                                        , playlistId = ""
                                        , thumbnailUrl = Nothing
                                        , publishedAt = v.snippet.publishedAt
                                        , liveStatus = Api.YoutubeModel.Unknown
                                        , statsOnConclusion = Nothing
                                        , statsAfter24Hours = Nothing
                                        , reportAfter24Hours = Nothing
                                        , liveChatId = Nothing
                                        , chatMsgCount = Nothing
                                        , ctr = Nothing
                                        , liveViews = Nothing
                                        }
                                    )
                                |> List.map (\v -> ( v.id, v ))
                                |> Dict.fromList

                        newModel =
                            { model
                                | videos = Dict.union newVideos model.videos
                            }
                    in
                    ( newModel, Cmd.none )

                Err error ->
                    ( model, Cmd.none )
                        |> log ("Failed to fetch competitor videos for channel : " ++ channelId ++ "\n" ++ httpErrToString error) Error

        Batch_ExportToSheet time ->
            -- ok jr, keep up!
            -- goal:
            -- * we want remove all the sheets, then put all the sheets back from the current data
            -- logic:
            -- * add a temp sheet since we can't remove the last sheet
            -- * remove all the other sheets
            -- * add all the sheets back
            -- * remove the temp sheet
            -- * put the data on the sheets per playlist
            ( model, GoogleSheetsApi.addSheets "1K7_tstxNjCTuvRvKDw9XjtKn2sz77r0OfhjE8XBy16s" [ "temp____" ] DeleteSheets (sheetAccessToken model) )

        AddedSheets spreadsheetId sheetNames nextAction response ->
            case response of
                Ok response_ ->
                    case nextAction of
                        DeleteSheets ->
                            ( model, GoogleSheetsApi.getSheetIds spreadsheetId DeleteSheets (sheetAccessToken model) )

                        UpdateSheets tempIds ->
                            let
                                updates =
                                    ((model.playlists
                                        |> Dict.values
                                        |> List.filter .monitor
                                        |> List.map (\p -> ( p.id, p.title ))
                                     )
                                        ++ [ ( "*", "All" ), ( "**", "Competitors" ) ]
                                        |> List.map (\( id, title ) -> ( id, title |> String.replace " " "_", getVideos model id |> tabulateVideoData model ))
                                        |> List.map
                                            (\( id, title, data ) ->
                                                GoogleSheetsApi.updateSheet spreadsheetId title data (UpdateSheets []) (sheetAccessToken model)
                                            )
                                    )
                                        ++ [ GoogleSheetsApi.deleteSheets spreadsheetId tempIds Done (sheetAccessToken model) ]
                            in
                            ( model, Cmd.batch updates )

                        _ ->
                            ( model, Cmd.none )

                Err error ->
                    ( model, Cmd.none )
                        |> log
                            ("Failed to add sheets to spreadsheet : "
                                ++ spreadsheetId
                                ++ "\n"
                                ++ httpErrToString error
                                ++ "\n"
                                ++ (sheetNames |> String.join ",")
                            )
                            Error

        DeletedSheets spreadsheetId sheetIds nextAction response ->
            case response of
                Ok response_ ->
                    case nextAction of
                        AddSheets tempIds ->
                            -- goal:
                            -- * add a sheet for each playlist
                            -- * add a sheet with all monitored data
                            -- * add a sheet with all competitor data
                            -- logic:
                            -- * add sheets for each monitored playlist
                            -- * add a sheet with all monitored data
                            -- * add a sheet with all competitor data
                            let
                                newSheetnames =
                                    (model.playlists
                                        |> Dict.filter (\_ p -> p.monitor)
                                        |> Dict.values
                                        |> List.map .title
                                        |> List.sort
                                    )
                                        ++ [ "All", "Competitors" ]
                                        |> List.map (String.replace " " "_")
                                        |> List.Extra.uniqueBy String.toLower

                                _ =
                                    Debug.log "tempIds" tempIds
                            in
                            ( model
                            , Cmd.batch
                                [ GoogleSheetsApi.addSheets spreadsheetId newSheetnames (UpdateSheets tempIds) (sheetAccessToken model)
                                ]
                            )

                        _ ->
                            ( model, Cmd.none )

                Err error ->
                    ( model, Cmd.none )
                        |> log ("Failed to delete sheets from spreadsheet : " ++ spreadsheetId ++ "\n" ++ httpErrToString error) Error

        GotSheetIds spreadsheetId nextAction response ->
            case nextAction of
                DeleteSheets ->
                    case response of
                        Result.Ok response_ ->
                            let
                                ( sheetIds, tempIds ) =
                                    response_.sheets
                                        |> List.map .properties
                                        |> List.partition (\p -> p.title /= "temp____")

                                ( sheetIds_, tempIds_ ) =
                                    ( sheetIds
                                        |> List.map .sheetId
                                    , tempIds
                                        |> List.map .sheetId
                                    )
                            in
                            ( model, GoogleSheetsApi.deleteSheets spreadsheetId sheetIds_ (AddSheets tempIds_) (sheetAccessToken model) )

                        Result.Err error ->
                            ( model, Cmd.none )
                                |> log ("Failed to fetch sheet ids for spreadsheet : " ++ spreadsheetId ++ "\n" ++ httpErrToString error) Error

                _ ->
                    ( model, Cmd.none )

        SheetUpdated spreadsheetId sheetName nextAction response ->
            case response of
                Result.Ok response_ ->
                    ( model, Cmd.none )
                        |> log ("Sheet updated : " ++ sheetName) Info

                Result.Err error ->
                    ( model, Cmd.none )
                        |> log ("Failed to update sheet : " ++ sheetName ++ "\n" ++ httpErrToString error) Error

        Tick time ->
            ( { model | time = time }, Cmd.none )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Cmd BackendMsg )
updateFromFrontend sessionId clientId msg2 model =
    case msg2 of
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

                latestVideoTimes =
                    playlists |> Dict.map (\_ p -> playlist_getLatestVideo model p.id)

                schedules =
                    model.schedules
                        |> Dict.filter (\_ v -> playlists |> Dict.member v.playlistId)
            in
            case channel of
                Just channel_ ->
                    ( model
                    , sendToPage clientId <|
                        Gen.Msg.Channel__Id_ <|
                            Pages.Channel.Id_.GotChannelAndPlaylists channel_ playlists latestVideoTimes schedules
                    )

                Nothing ->
                    ( model, Cmd.none )

        AttemptGetLogs latest numberToFetch ->
            ( model
            , sendToPage clientId <|
                Gen.Msg.Log <|
                    Pages.Log.GotLogs
                        latest
                        (model.logs |> List.drop latest |> List.take numberToFetch)
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
            ( model
            , sendToPage clientId <|
                Gen.Msg.Playlist__Id_ <|
                    Pages.Playlist.Id_.GotVideos <|
                        getVideos model playlistId
            )

        AttemptYeetLogs ->
            ( { model | logs = [] }, Cmd.none )

        AttemptBatch_RefreshAccessTokens ->
            ( model, performNowWithTime Batch_RefreshAccessTokens )

        AttemptBatch_RefreshAllChannels ->
            ( model, performNowWithTime Batch_RefreshAllChannels )

        AttemptBatch_RefreshAllPlaylists ->
            ( model, performNowWithTime Batch_RefreshAllPlaylists )

        AttemptBatch_RefreshAllVideosFromPlaylists ->
            ( model, performNowWithTime Batch_RefreshAllVideosFromPlaylists )

        AttemptBatch_GetLiveVideoStreamData ->
            ( model, performNowWithTime Batch_GetLiveVideoStreamData )

        AttemptBatch_GetVideoStats ->
            ( model, performNowWithTime Batch_GetVideoStats )

        AttemptBatch_GetChatMessages ->
            ( model, performNowWithTime Batch_GetChatMessages )

        AttemptBatch_GetVideoDailyReports ->
            ( model, performNowWithTime Batch_GetVideoDailyReports )

        AttemptBatch_GetVideoStatisticsAtTime ->
            ( model, performNowWithTime Batch_GetVideoStatisticsAtTime )

        AttemptYeetVideos ->
            ( { model
                | videos = Dict.empty
              }
            , Cmd.none
            )

        AttemptBatch_GetCompetitorVideos ->
            ( model
            , Cmd.batch
                [ performNowWithTime Batch_GetCompetitorChannelIds
                , performNowWithTime Batch_GetCompetitorVideos
                ]
            )

        AttemptYeetCredentials email ->
            ( { model
                | clientCredentials =
                    model.clientCredentials
                        |> Dict.remove email
              }
            , Cmd.none
            )

        AttemptGetVideoDetails videoId ->
            let
                video =
                    model.videos
                        |> Dict.get videoId

                liveVideoDetails =
                    video
                        |> Maybe.andThen (\v -> model.liveVideoDetails |> Dict.get v.id)

                currentViewers =
                    model.currentViewers
                        |> Dict.filter (\( videoId_, _ ) _ -> videoId_ == videoId)
                        |> Dict.values

                videoStats =
                    model.videoStatisticsAtTime
                        |> Dict.filter (\_ s -> s.videoId == videoId)
                        |> Dict.values
                        |> List.sortBy (.timestamp >> Time.posixToMillis)

                channelTitle =
                    model.videos
                        |> Dict.get videoId
                        |> Maybe.map .videoOwnerChannelTitle
                        |> Maybe.withDefault ""

                playlistTitle =
                    video
                        |> Maybe.map .playlistId
                        |> Maybe.andThen (\playlistId -> model.playlists |> Dict.get playlistId)
                        |> Maybe.map .title
                        |> Maybe.withDefault ""
            in
            ( model
            , sendToPage clientId <|
                Gen.Msg.Video__Id_ <|
                    Pages.Video.Id_.GotVideoDetails
                        { channelTitle = channelTitle
                        , playlistTitle = playlistTitle
                        , video = video
                        , liveVideoDetails = liveVideoDetails
                        , currentViewers = currentViewers
                        , videoStatisticsAtTime = videoStats
                        }
            )

        AttemptBatch_ExportToSheet ->
            ( model, performNowWithTime Batch_ExportToSheet )

        AttemptUpdateVideoCtr videoId ctr ->
            ( { model
                | videos =
                    model.videos
                        |> Dict.get videoId
                        |> Maybe.map (\v -> { v | ctr = ctr })
                        |> Maybe.map (\v -> model.videos |> Dict.insert videoId v)
                        |> Maybe.withDefault model.videos
              }
            , Cmd.none
            )

        AttemptUpdateVideoLiveViews videoId liveViews ->
            ( { model
                | videos =
                    model.videos
                        |> Dict.get videoId
                        |> Maybe.map (\v -> { v | liveViews = liveViews })
                        |> Maybe.map (\v -> model.videos |> Dict.insert videoId v)
                        |> Maybe.withDefault model.videos
              }
            , Cmd.none
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


video_getAccessToken model videoId =
    let
        accessToken =
            model.videos
                |> Dict.get videoId
                |> Maybe.map .videoOwnerChannelId
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

        altAccessToken =
            model.clientCredentials
                |> Dict.values
                |> List.sortBy (\cc -> cc.timestamp)
                |> List.reverse
                |> List.head
                |> Maybe.map .accessToken
    in
    case ( accessToken, altAccessToken ) of
        ( Just accessToken_, _ ) ->
            Just accessToken_

        ( Nothing, Just altAccessToken_ ) ->
            Just altAccessToken_

        ( Nothing, Nothing ) ->
            Nothing


playlist_getAccessToken model playlistId =
    model.playlists
        |> Dict.get playlistId
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


playlist_getLatestVideo model playlistId =
    model.videos
        |> Dict.filter (\_ v -> v.playlistId == playlistId)
        |> Dict.values
        |> List.map (\v -> v.publishedAt |> strToIntTime)
        |> List.sort
        |> List.reverse
        |> List.head
        |> Maybe.withDefault 0


fnLog msg fn thing =
    let
        _ =
            thing
                |> fn
                |> Debug.log msg
    in
    thing


video_lookupCompetingVideo : Model -> Api.YoutubeModel.Video -> Dict.Dict String Api.YoutubeModel.Video
video_lookupCompetingVideo model video =
    let
        competingChannelIds : List String
        competingChannelIds =
            model.playlists
                |> Dict.filter (\_ p -> p.id == video.playlistId)
                |> Dict.values
                |> List.map (.competitorHandles >> Set.toList)
                |> List.concat
                |> List.map
                    (\handle ->
                        model.channelHandleMap
                            |> List.filter (\( h, _ ) -> h == handle)
                            |> List.map Tuple.second
                    )
                |> List.concat
                |> Set.fromList
                |> Set.toList
                |> Debug.log "competingChannelIds"

        altCompetitorChannelIds : List String
        altCompetitorChannelIds =
            model.playlists
                |> Dict.filter (\_ p -> p.id == video.playlistId)
                |> Dict.values
                |> List.map (.competitorIds >> Set.toList)
                |> List.concat
                |> List.Extra.unique
                |> Debug.log "altCompetitorChannelIds"

        ourLiveVideoDetails =
            model.liveVideoDetails
                |> Dict.get video.id

        competitorVideos : Dict.Dict String Api.YoutubeModel.Video
        competitorVideos =
            model.videos
                |> Dict.filter (\_ v -> List.member v.videoOwnerChannelId altCompetitorChannelIds)

        competingLiveVideoDetails : Dict.Dict String Api.YoutubeModel.LiveVideoDetails
        competingLiveVideoDetails =
            model.liveVideoDetails
                |> Dict.filter (\_ c -> Dict.member c.videoId competitorVideos)
                |> Dict.filter
                    (\_ competitorLiveVideoDetails ->
                        case ourLiveVideoDetails of
                            Just ourLiveVideoDetails_ ->
                                timespansOverlap
                                    (video_actualStartTime model ourLiveVideoDetails_ - (3 * hour))
                                    (video_actualEndTime model ourLiveVideoDetails_ + (3 * hour))
                                    (video_actualStartTime model competitorLiveVideoDetails)
                                    (video_actualEndTime model competitorLiveVideoDetails)

                            Nothing ->
                                False
                    )

        competitorVideoToReturn =
            model.videos
                |> Dict.filter (\_ v -> Dict.member v.id competingLiveVideoDetails)
    in
    competitorVideoToReturn





competitorHandle_getAccessToken model handle =
    model.playlists
        |> Dict.filter (\_ p -> Set.member handle p.competitorHandles)
        |> Dict.values
        |> List.head
        |> Maybe.andThen (\p -> playlist_getAccessToken model p.id)




groupByComparable toComparable list =
    list
        |> List.sortBy toComparable
        |> List.foldr
            (\item acc ->
                Dict.insert
                    (toComparable item)
                    (item :: Maybe.withDefault [] (Dict.get (toComparable item) acc))
                    acc
            )
            Dict.empty
        |> Dict.toList


accessToken_getLatest model =
    model.clientCredentials
        |> Dict.values
        |> List.sortBy (\cc -> cc.timestamp)
        |> List.reverse
        |> List.head
        |> Maybe.map .accessToken
        |> Maybe.withDefault "123-an-error-you'll-see"


getVideos : Model -> String -> Api.YoutubeModel.VideoResults
getVideos model playlistId =
    let
        playlists : Dict.Dict String Api.YoutubeModel.Playlist
        playlists =
            (case playlistId of
                "*" ->
                    model.playlists
                        |> Dict.filter (\_ v -> v.monitor)

                playlistId_ ->
                    model.playlists
                        |> Dict.filter (\_ v -> v.id == playlistId_)
            )
                |> Dict.map (\_ p -> { p | description = "" })

        videos : Dict.Dict String Api.YoutubeModel.Video
        videos =
            model.videos
                |> Dict.filter
                    (\_ v ->
                        v.playlistId
                            == playlistId
                            || (playlistId
                                    == "*"
                                    && Dict.member v.playlistId playlists
                                    || (playlistId == "**" && v.playlistId == "")
                               )
                    )
                |> Dict.filter (\_ v -> video_isNew v)
                |> Dict.map (\_ v -> { v | description = "" })

        liveVideoDetails : Dict.Dict String Api.YoutubeModel.LiveVideoDetails
        liveVideoDetails =
            model.liveVideoDetails
                |> Dict.filter (\_ v -> Dict.member v.videoId videos)

        currentViewers : Dict.Dict ( String, Int ) Api.YoutubeModel.CurrentViewers
        currentViewers =
            model.currentViewers
                |> Dict.filter (\( videoId, _ ) _ -> Dict.member videoId videos)

        videoStats : Dict.Dict ( String, Int ) Api.YoutubeModel.VideoStatisticsAtTime
        videoStats =
            model.videoStatisticsAtTime
                |> Dict.filter (\_ s -> Dict.member s.videoId videos)
                |> Dict.values
                |> List.sortBy (.timestamp >> Time.posixToMillis >> (*) -1)
                --|> List.take 24
                |> List.map (\s -> ( ( s.videoId, s.timestamp |> Time.posixToMillis ), s ))
                |> Dict.fromList

        

        videoChannels : Dict.Dict String String
        videoChannels =
            model.videos
                |> Dict.map (\_ v -> v.videoOwnerChannelTitle)

        -- this value should be "our video id" -> "competitor video id" -> video
        -- for each of "our" videos, find the competitor video that was live at the same time
        competitorVideos : Dict.Dict String (Dict.Dict String Api.YoutubeModel.Video)
        competitorVideos =
            videos
                |> Dict.map (\_ v -> video_lookupCompetingVideo model v)
                |> Dict.filter (\_ v -> Dict.size v > 0)

        competitorVideoStats : Dict.Dict ( String, Int ) Api.YoutubeModel.VideoStatisticsAtTime
        competitorVideoStats =
            model.videoStatisticsAtTime
                |> Dict.filter (\( videoId, _ ) _ -> Dict.member videoId competitorVideos)
                |> Dict.values
                |> List.sortBy (.timestamp >> Time.posixToMillis >> (*) -1)
                --|> List.take 24
                |> List.map (\s -> ( ( s.videoId, s.timestamp |> Time.posixToMillis ), s ))
                |> Dict.fromList

        allStats = Dict.union competitorVideoStats videoStats


        uniqueCompetitorIds =
            competitorVideos
                |> Dict.values
                |> List.map Dict.values
                |> List.concat
                |> List.map .videoOwnerChannelId
                |> List.Extra.unique

        competitorsVsUs =
            videos
                |> Dict.keys
                |> List.map
                    (\videoId ->
                        ( videoId
                        , uniqueCompetitorIds
                            |> List.map
                                (\competitorId ->
                                    ( competitorId, calculateCompetingViewsPercentage model videoId competitorId )
                                )
                            |> Dict.fromList
                        )
                    )
                |> Dict.fromList
    in
    { playlists = playlists
    , videos = videos
    , liveVideoDetails = liveVideoDetails
    , currentViewers = currentViewers
    , videoChannels = videoChannels
    , videoStatisticsAtTime = allStats
    , competitorVideos = competitorVideos
    , competitorsVsUs = competitorsVsUs
    }


sheetAccessToken model =
    let
        accessToken =
            model.clientCredentials |> Dict.get "schalk.dormehl@gmail.com" |> Maybe.map .accessToken |> Maybe.withDefault ""
    in
    accessToken



--"ya29.a0AfB_byBj-AEs-2bu_uNdb3EZOzHiYw5yYeRFHbaq7zfmrZv9aIWCMeFmCusTAPFJIuJzB0O-sI0dOVnedZskD2_3h9fNURq4gsAMC3uhs22F6D-xr1a1BwH76nXATk_mKIFxH01BtuJCyAbdrnvBNS6S9zMu1aBuMdJ3kAaCgYKAVISARASFQHGX2MiyEMhlFa8NvoR0A0-DKN2pw0173"


tabulateVideoData : Model -> Api.YoutubeModel.VideoResults -> List (List String)
tabulateVideoData model videoResults =
    -- goal:
    -- * return the same data that Pages.Playlist.Id_ displays
    -- * make sure the headers are the same
    -- * make sure the data is the same
    let
        uniqueCompetitorTitles =
            videoResults.competitorVideos
                |> Dict.values
                |> List.map Dict.values
                |> List.concat
                |> List.map .videoOwnerChannelTitle
                |> List.Extra.unique

        uniqueCompetitorIds =
            videoResults.competitorVideos
                |> Dict.values
                |> List.map Dict.values
                |> List.concat
                |> List.map .videoOwnerChannelId
                |> List.Extra.unique

        sheetString str =
            "\"" ++ str ++ "\""

        headers =
            [ "Published at"
            , "Link"
            , "Channel"
            , "Title"
            , "Status"
            , "Lobby"
            , "Peak"
            , "Live views est"
            , "Live Likes"
            , "24hr views"
            , "Subs gained"
            , "Watch Proportion"
            , "Details"
            ]
                ++ uniqueCompetitorTitles
                |> List.map sheetString

        data =
            videoResults.videos
                |> Dict.values
                |> List.sortBy .publishedAt
                |> List.map
                    (\video ->
                        let
                            lastStats =
                                videoResults.videoStatisticsAtTime
                                    |> Dict.filter (\( videoId, _ ) _ -> videoId == video.id)
                                    |> Dict.values
                                    |> List.sortBy (.timestamp >> Time.posixToMillis >> (*) -1)
                                    |> List.head
                        in
                        ([ video.publishedAt
                         , "https://www.youtube.com/watch?v=" ++ video.id
                         , video.videoOwnerChannelTitle
                         , video.title |> escapeStringForJson
                         , video.liveStatus
                            |> Api.YoutubeModel.liveStatusToString
                         , video_lobbyEstimate videoResults.liveVideoDetails videoResults.currentViewers video.id
                            |> Maybe.map String.fromInt
                            |> Maybe.withDefault ""
                         , video_peakViewers videoResults.currentViewers video.id
                            |> Maybe.map String.fromInt
                            |> Maybe.withDefault ""
                         , case video_liveViews video (videoResults.currentViewers |> Dict.values |> List.filter (\c -> c.videoId == video.id)) of
                            Actual liveViews ->
                                liveViews
                                    |> String.fromInt

                            Estimate liveViewsEstimate ->
                                liveViewsEstimate
                                    |> String.fromInt

                            Unknown_ ->
                                ""
                         , case video.statsOnConclusion of
                            Just statsOnConclusion_ ->
                                statsOnConclusion_.likeCount
                                    |> String.fromInt

                            _ ->
                                ""
                         , lastStats
                            |> Maybe.map .viewCount
                            |> Maybe.map String.fromInt
                            |> Maybe.withDefault ""

                         -- , (case video.statsAfter24Hours of
                         --     Just statsAfter24Hours_ ->
                         --         statsAfter24Hours_.viewCount
                         --             |> String.fromInt
                         --     _ ->
                         --         ""
                         --   )
                         , -- "Subs Gained"
                           case video.reportAfter24Hours of
                            Just reportAfter24Hours_ ->
                                reportAfter24Hours_.subscribersGained
                                    + reportAfter24Hours_.subscribersLost
                                    |> String.fromInt

                            _ ->
                                ""
                         , -- "Watch %"
                           case video.reportAfter24Hours of
                            Just reportAfter24Hours_ ->
                                reportAfter24Hours_.averageViewPercentage
                                    / 100
                                    |> String.fromFloat

                            _ ->
                                ""
                         , "https://cb-stats.lamdera.app/video/"
                            ++ video.id
                         ]
                            ++ (uniqueCompetitorIds
                                    |> List.map
                                        (\competitorId ->
                                            videoResults.competitorsVsUs
                                                |> Dict.get video.id
                                                |> Maybe.andThen (\competitorsVsUs_ -> Dict.get competitorId competitorsVsUs_)
                                                |> Maybe.andThen (Maybe.map String.fromFloat)
                                                |> Maybe.withDefault ""
                                        )
                               )
                        )
                            |> List.map sheetString
                    )
    in
    headers :: data


escapeStringForJson : String -> String
escapeStringForJson str =
    str
        |> String.replace "\"" "'"
        |> String.replace "\n" " "
        |> String.replace "\u{000D}" " "
        |> String.replace "\t" " "
        |> String.replace "[" "("
        |> String.replace "]" ")"


