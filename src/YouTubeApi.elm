module YouTubeApi exposing (..)

import Api.Time exposing (..)
import Http
import Json.Auto.AccessToken
import Json.Auto.Channels
import Json.Auto.PlaylistItems
import Json.Auto.Playlists
import Json.Auto.VideoStats
import Json.Bespoke.LiveBroadcastDecoder
import Json.Bespoke.ReportDecoder
import Json.Bespoke.VideoDecoder
import Json.Decode as Decode
import Json.Encode as Encode
import Task exposing (Task)
import Time exposing (..)
import Types exposing (BackendMsg(..))
import Url



-- Type alias for token management


type alias Token_ =
    { refreshToken : String
    , accessToken : String
    , timeout : Time.Posix
    }


handleJsonResponse : Decode.Decoder a -> Http.Response String -> Result Http.Error a
handleJsonResponse decoder response =
    case response of
        Http.BadUrl_ url ->
            Err (Http.BadUrl url)

        Http.Timeout_ ->
            Err Http.Timeout

        Http.BadStatus_ { statusCode } _ ->
            Err (Http.BadStatus statusCode)

        Http.NetworkError_ ->
            Err Http.NetworkError

        Http.GoodStatus_ _ body ->
            case Decode.decodeString decoder body of
                Err _ ->
                    Err (Http.BadBody body)

                Ok result ->
                    Ok result


oauthEndpoint : String
oauthEndpoint =
    "https://oauth2.googleapis.com/token"


refreshAccessToken : String -> String -> String -> Task Http.Error Json.Auto.AccessToken.Root
refreshAccessToken clientId clientSecret refreshToken =
    let
        jsonRequest =
            Encode.object
                [ ( "client_id", Encode.string clientId )
                , ( "client_secret", Encode.string clientSecret )
                , ( "refresh_token", Encode.string refreshToken )
                , ( "grant_type", Encode.string "refresh_token" )
                ]
    in
    -- Implement the HTTP request to Google OAuth to get a new access token
    -- This is a placeholder for the actual HTTP task
    -- Task.succeed "new_access_token"
    Http.task
        { method = "POST"
        , headers = []
        , url = oauthEndpoint
        , body = Http.jsonBody jsonRequest
        , resolver = Http.stringResolver <| handleJsonResponse <| Json.Auto.AccessToken.rootDecoder
        , timeout = Nothing
        }


refreshAccessTokenCmd clientId clientSecret refreshToken email time =
    let
        jsonRequest =
            Encode.object
                [ ( "client_id", Encode.string clientId )
                , ( "client_secret", Encode.string clientSecret )
                , ( "refresh_token", Encode.string refreshToken )
                , ( "grant_type", Encode.string "refresh_token" )
                ]
    in
    Http.post
        { url = oauthEndpoint
        , body = Http.jsonBody jsonRequest
        , expect = Http.expectJson (GotAccessToken email time) Json.Auto.AccessToken.rootDecoder
        }


getChannelsCmd : String -> String -> Cmd BackendMsg
getChannelsCmd email accessToken =
    let
        url =
            "https://www.googleapis.com/youtube/v3/channels?part=snippet&mine=true"
    in
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (GotChannels email) Json.Auto.Channels.rootDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


getPlaylistsCmd : String -> String -> Cmd BackendMsg
getPlaylistsCmd channelId accessToken =
    let
        url =
            "https://www.googleapis.com/youtube/v3/playlists?part=snippet&mine=true&maxResults=50"
    in
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (GotPlaylists channelId) Json.Auto.Playlists.rootDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


getVideosCmd pageToken playlistId accessToken =
    let
        url =
            "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50"
                ++ "&playlistId="
                ++ playlistId
                ++ (pageToken |> Maybe.map (\token -> "&pageToken=" ++ token) |> Maybe.withDefault "")
    in
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (GotVideosFromPlaylist playlistId) Json.Auto.PlaylistItems.rootDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


getVideoLiveStreamDataCmd : Posix -> String -> String -> Cmd BackendMsg
getVideoLiveStreamDataCmd timestamp videoId accessToken =
    let
        url =
            "https://www.googleapis.com/youtube/v3/videos?part=liveStreamingDetails&id="
                ++ videoId
    in
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (GotLiveVideoStreamData timestamp videoId) Json.Bespoke.VideoDecoder.rootDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


getVideoStats timestamp videoId msg accessToken =
    let
        url =
            "https://www.googleapis.com/youtube/v3/videos?part=statistics&id="
                ++ videoId
            |> Debug.log "stats_url"
    in
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (msg timestamp videoId) Json.Auto.VideoStats.rootDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


getChatMessagesCmd pageToken liveBroadcastId accessToken =
    let
        url =
            "https://www.googleapis.com/youtube/v3/liveChat/messages?part=snippet,authorDetails&liveChatId="
                ++ liveBroadcastId
                ++ (pageToken |> Maybe.map (\token -> "&pageToken=" ++ token) |> Maybe.withDefault "")
    in
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (GotChatMessages liveBroadcastId) Json.Bespoke.LiveBroadcastDecoder.rootDecoder
        , timeout = Nothing
        , tracker = Nothing
        }



-- example:
-- https://youtubeanalytics.googleapis.com/v2/reports?endDate=2014-02-04&ids=channel==MINE&metrics=averageViewPercentage,subscribersGained,subscribersLost,views,&startDate=2014-02-04&filters=video==Cw27x_xAPmI&dimensions=day


getVideoDailyReportCmd videoId date accessToken =
    let
        url =
            "https://youtubeanalytics.googleapis.com/v2/reports?ids=channel==MINE&metrics=averageViewPercentage,subscribersGained,subscribersLost,views,&filters=video=="
                ++ videoId
                ++ "&dimensions=day&startDate="
                ++ (date |> String.left 10 |> Url.percentEncode)
                ++ "&endDate="
                ++ (date |> String.left 10 |> Url.percentEncode)
            |> Debug.log ("access_token " ++ accessToken ++ " url") 

       
    in
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (GotVideoDailyReport videoId) Json.Bespoke.ReportDecoder.youtubeAnalyticsDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
