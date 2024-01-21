module GoogleSheetsApi exposing (..)

import Api.YoutubeModel
import Dict exposing (Dict)
import Http
import Json.Auto.AccessToken
import Json.Auto.ChannelHandle
import Json.Auto.Channels
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
import Types exposing (BackendMsg(..))
import Url
import Utils.Time exposing (..)
import Api.SheetModel exposing (..)



-- This file translates the Elm types into the comma delimited strings that are required by the Google Sheets API


exportVideoResults : Api.YoutubeModel.VideoResults -> String -> String -> Cmd BackendMsg
exportVideoResults results spreadsheetId accessToken =
    let
        commaStringListsPerTab : Dict String (List String)
        commaStringListsPerTab =
            Dict.empty

        updateCommands : Cmd BackendMsg
        updateCommands =
            commaStringListsPerTab
                |> Dict.map (\v l -> updateSheet spreadsheetId v l accessToken)
                |> Dict.values
                |> Cmd.batch
    in
    updateCommands


updateSheet : String -> String -> List String -> String -> Cmd BackendMsg
updateSheet spreadsheetId sheetName listOfValues accessToken =
    let
        commaDelimitedString : String
        commaDelimitedString =
            String.join "," listOfValues

        url : String
        url =
            "https://sheets.googleapis.com/v4/spreadsheets/" ++ spreadsheetId ++ "/values/" ++ sheetName ++ "?valueInputOption=USER_ENTERED"

        body : String
        body =
            "{\"values\":[[" ++ commaDelimitedString ++ "]]}"
    in
    Http.request
        { method = "PUT"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.stringBody "application/json" body
        , expect = Http.expectWhatever (SheetUpdated spreadsheetId sheetName)
        , timeout = Nothing
        , tracker = Nothing
        }


getSheetIds : String -> String -> Cmd BackendMsg
getSheetIds spreadsheetId accessToken =
    let
        url =
            "https://sheets.googleapis.com/v4/spreadsheets/" ++ spreadsheetId

        sheetsDecoder =
            Decode.field "sheets" (Decode.list sheetDecoder)
    in
    Http.request
        { method = "GET"
        , headers = [ Http.header "Authorization" ("Bearer " ++ accessToken) ]
        , url = url
        , body = Http.emptyBody
        , expect = Http.expectJson (GotSheetIds spreadsheetId) sheetsDecoder
        , timeout = Nothing
        , tracker = Nothing
        }





deleteSheet : String -> List String -> String -> Cmd BackendMsg
deleteSheet spreadsheetId sheetIds accessToken =
    let
        url =
            "https://sheets.googleapis.com/v4/spreadsheets/" ++ spreadsheetId ++ ":batchUpdate"

        requestBody =
            Encode.list deleteSheetReqBody sheetIds |> Encode.encode 0
    in
    Http.request
        { method = "POST"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ accessToken)
            , Http.header "Content-Type" "application/json"
            ]
        , url = url
        , body = Http.stringBody "application/json" requestBody
        , expect = Http.expectWhatever (DeletedSheets spreadsheetId sheetIds)
        , timeout = Nothing
        , tracker = Nothing
        }




addSheets : String -> List Sheet -> String -> Cmd BackendMsg
addSheets spreadsheetId newSheets accessToken =
    let
        url =
            "https://sheets.googleapis.com/v4/spreadsheets/" ++ spreadsheetId ++ ":batchUpdate"

        requestBody =
            Encode.object
                [ ( "requests", Encode.list newSheetRequestBody newSheets )
                ]
                |> Encode.encode 0
    in
    Http.request
        { method = "POST"
        , headers =
            [ Http.header "Authorization" ("Bearer " ++ accessToken)
            , Http.header "Content-Type" "application/json"
            ]
        , url = url
        , body = Http.stringBody "application/json" requestBody
        , expect = Http.expectWhatever (AddedSheets spreadsheetId newSheets)
        , timeout = Nothing
        , tracker = Nothing
        } 
