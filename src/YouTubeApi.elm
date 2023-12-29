module YouTubeApi exposing (..)

import Json.Auto.Playlists
import Json.Auto.Channels
import Http
import Json.Auto.AccessToken
import Json.Decode as Decode
import Json.Encode as Encode
import Task exposing (Task)
import Time
import Types exposing (BackendMsg(..))



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


--refreshAccessTokenCmd : String -> String -> String -> String -> Time.Posix -> Cmd msg
refreshAccessTokenCmd clientId clientSecret refreshToken email time  =
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
            "https://www.googleapis.com/youtube/v3/playlists?part=snippet&mine=true&maxResults=5000"
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
