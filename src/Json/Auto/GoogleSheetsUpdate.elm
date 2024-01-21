module Json.Auto.GoogleSheetsUpdate exposing (..)

import Json.Decode
import Json.Encode



-- Required packages:
-- * elm/json


type alias Root =
    { spreadsheetId : String
    , updatedCells : Int
    , updatedColumns : Int
    , updatedRange : String
    , updatedRows : Int
    }


rootDecoder : Json.Decode.Decoder Root
rootDecoder =
    Json.Decode.map5 Root
        (Json.Decode.field "spreadsheetId" Json.Decode.string)
        (Json.Decode.field "updatedCells" Json.Decode.int)
        (Json.Decode.field "updatedColumns" Json.Decode.int)
        (Json.Decode.field "updatedRange" Json.Decode.string)
        (Json.Decode.field "updatedRows" Json.Decode.int)
