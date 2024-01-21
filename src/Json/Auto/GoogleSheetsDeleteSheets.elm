module Json.Auto.GoogleSheetsDeleteSheets exposing (..)

import Json.Decode
import Json.Encode



-- Required packages:
-- * elm/json


type alias Root =
    { requests : List RootRequestsObject
    }


type alias RootRequestsObject =
    { deleteSheet : RootRequestsObjectDeleteSheet
    }


type alias RootRequestsObjectDeleteSheet =
    { sheetId : Int
    }


rootDecoder : Json.Decode.Decoder Root
rootDecoder =
    Json.Decode.map Root
        (Json.Decode.field "requests" <| Json.Decode.list rootRequestsObjectDecoder)


rootRequestsObjectDecoder : Json.Decode.Decoder RootRequestsObject
rootRequestsObjectDecoder =
    Json.Decode.map RootRequestsObject
        (Json.Decode.field "deleteSheet" rootRequestsObjectDeleteSheetDecoder)


rootRequestsObjectDeleteSheetDecoder : Json.Decode.Decoder RootRequestsObjectDeleteSheet
rootRequestsObjectDeleteSheetDecoder =
    Json.Decode.map RootRequestsObjectDeleteSheet
        (Json.Decode.field "sheetId" Json.Decode.int)


encodedRoot : Root -> Json.Encode.Value
encodedRoot root =
    Json.Encode.object
        [ ( "requests", Json.Encode.list encodedRootRequestsObject root.requests )
        ]


encodedRootRequestsObject : RootRequestsObject -> Json.Encode.Value
encodedRootRequestsObject rootRequestsObject =
    Json.Encode.object
        [ ( "deleteSheet", encodedRootRequestsObjectDeleteSheet rootRequestsObject.deleteSheet )
        ]


encodedRootRequestsObjectDeleteSheet : RootRequestsObjectDeleteSheet -> Json.Encode.Value
encodedRootRequestsObjectDeleteSheet rootRequestsObjectDeleteSheet =
    Json.Encode.object
        [ ( "sheetId", Json.Encode.int rootRequestsObjectDeleteSheet.sheetId )
        ]
