module GoogleSheetsApi exposing (..)

import Api.YoutubeModel
import Dict exposing (Dict)
import Http
import Json.Auto.AccessToken
import Json.Auto.ChannelHandle
import Json.Auto.Channels
import Json.Auto.GoogleSheetsAddSheets
import Json.Auto.GoogleSheetsDeleteSheets
import Json.Auto.GoogleSheetsDetails
import Json.Auto.PlaylistItems
import Json.Auto.Playlists
import Json.Auto.Search
import Json.Auto.VideoStats
import Json.Bespoke.LiveBroadcastDecoder
import Json.Bespoke.ReportDecoder
import Json.Bespoke.VideoDecoder
import Json.Decode as Decode
import Json.Encode as Encode
import Task exposing (Task)
import Time exposing (..)
import Types exposing (BackendMsg(..), NextAction(..))
import Url
import Utils.Time exposing (..)



-- This file translates the Elm types into the comma delimited strings that are required by the Google Sheets API


exportVideoResults : Api.YoutubeModel.VideoResults -> String -> NextAction -> String -> Cmd BackendMsg
exportVideoResults results spreadsheetId nextAction accessToken =
    let
        commaStringListsPerTab : Dict String (List String)
        commaStringListsPerTab =
            Dict.empty

        updateCommands : Cmd BackendMsg
        updateCommands =
            commaStringListsPerTab
                |> Dict.map (\v l -> updateSheet spreadsheetId v l nextAction accessToken)
                |> Dict.values
                |> Cmd.batch
    in
    updateCommands


updateSheet : String -> String -> List String -> NextAction -> String -> Cmd BackendMsg
updateSheet spreadsheetId sheetId listOfValues nextAction accessToken =
    let
        commaDelimitedString : String
        commaDelimitedString =
            String.join "," listOfValues

        url : String
        url =
            "https://sheets.googleapis.com/v4/spreadsheets/" ++ spreadsheetId ++ "/values/" ++ sheetId ++ "?valueInputOption=USER_ENTERED"

        body : String
        body =
            "{\"values\":[[" ++ commaDelimitedString ++ "]]}"
    in
    Http.request
        { method = "PUT"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.stringBody "application/json" body
        , expect = Http.expectWhatever (SheetUpdated spreadsheetId sheetId nextAction)
        , timeout = Nothing
        , tracker = Nothing
        }


getSheetIds : String -> NextAction -> String -> Cmd BackendMsg
getSheetIds spreadsheetId nextAction accessToken =
    let
        url =
            "https://sheets.googleapis.com/v4/spreadsheets/" ++ spreadsheetId
    in
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (GotSheetIds spreadsheetId nextAction) Json.Auto.GoogleSheetsDetails.rootDecoder
        , timeout = Nothing
        , tracker = Nothing
        }


deleteSheets : String -> List Int -> NextAction -> String -> Cmd BackendMsg
deleteSheets spreadsheetId sheetIds nextAction accessToken =
    let
        url =
            "https://sheets.googleapis.com/v4/spreadsheets/" ++ spreadsheetId ++ ":batchUpdate"

        requestBody =
            { requests =
                sheetIds
                    |> List.map
                        (\id ->
                            { deleteSheet =
                                { sheetId = id
                                }
                            }
                        )
            }
                |> Json.Auto.GoogleSheetsDeleteSheets.encodedRoot
    in
    Http.request
        { method = "POST"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ accessToken)
            , Http.header "Content-Type" "application/json"
            ]
        , url = url
        , body = Http.jsonBody requestBody
        , expect = Http.expectWhatever (DeletedSheets spreadsheetId sheetIds nextAction)
        , timeout = Nothing
        , tracker = Nothing
        }


addSheets : String -> List String -> NextAction -> String -> Cmd BackendMsg
addSheets spreadsheetId newSheetNames nextAction accessToken =
    let
        url =
            "https://sheets.googleapis.com/v4/spreadsheets/"
                ++ spreadsheetId
                ++ ":batchUpdate"
                |> Debug.log "url"

        requestBody =
            { requests =
                newSheetNames
                    |> List.map
                        (\name ->
                            { addSheet =
                                { properties = { title = name } }
                            }
                        )
            }
                |> Json.Auto.GoogleSheetsAddSheets.encodedRoot
                |> Debug.log "requestBody as String" 
    in
    Http.request
        { method = "POST"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ accessToken)
            , Http.header "Content-Type" "application/json"
            ]
        , url = url
        , body = Http.jsonBody requestBody
        , expect = Http.expectWhatever (AddedSheets spreadsheetId newSheetNames nextAction)
        , timeout = Nothing
        , tracker = Nothing
        }
