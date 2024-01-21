module Json.Auto.GoogleSheetsAddSheets exposing (..)

import Json.Decode
import Json.Encode



-- Required packages:
-- * elm/json


type alias Root =
    { requests : List RootRequestsObject
    }


type alias RootRequestsObject =
    { addSheet : RootRequestsObjectAddSheet
    }


type alias RootRequestsObjectAddSheet =
    { properties : RootRequestsObjectAddSheetProperties
    }


type alias RootRequestsObjectAddSheetProperties =
    { title : String
    }


rootDecoder : Json.Decode.Decoder Root
rootDecoder =
    Json.Decode.map Root
        (Json.Decode.field "requests" <| Json.Decode.list rootRequestsObjectDecoder)


rootRequestsObjectDecoder : Json.Decode.Decoder RootRequestsObject
rootRequestsObjectDecoder =
    Json.Decode.map RootRequestsObject
        (Json.Decode.field "addSheet" rootRequestsObjectAddSheetDecoder)


rootRequestsObjectAddSheetDecoder : Json.Decode.Decoder RootRequestsObjectAddSheet
rootRequestsObjectAddSheetDecoder =
    Json.Decode.map RootRequestsObjectAddSheet
        (Json.Decode.field "properties" rootRequestsObjectAddSheetPropertiesDecoder)


rootRequestsObjectAddSheetPropertiesDecoder : Json.Decode.Decoder RootRequestsObjectAddSheetProperties
rootRequestsObjectAddSheetPropertiesDecoder =
    Json.Decode.map RootRequestsObjectAddSheetProperties
        (Json.Decode.field "title" Json.Decode.string)


encodedRoot : Root -> Json.Encode.Value
encodedRoot root =
    Json.Encode.object
        [ ( "requests", Json.Encode.list encodedRootRequestsObject root.requests )
        ]


encodedRootRequestsObject : RootRequestsObject -> Json.Encode.Value
encodedRootRequestsObject rootRequestsObject =
    Json.Encode.object
        [ ( "addSheet", encodedRootRequestsObjectAddSheet rootRequestsObject.addSheet )
        ]


encodedRootRequestsObjectAddSheet : RootRequestsObjectAddSheet -> Json.Encode.Value
encodedRootRequestsObjectAddSheet rootRequestsObjectAddSheet =
    Json.Encode.object
        [ ( "properties", encodedRootRequestsObjectAddSheetProperties rootRequestsObjectAddSheet.properties )
        ]


encodedRootRequestsObjectAddSheetProperties : RootRequestsObjectAddSheetProperties -> Json.Encode.Value
encodedRootRequestsObjectAddSheetProperties rootRequestsObjectAddSheetProperties =
    Json.Encode.object
        [ ( "title", Json.Encode.string rootRequestsObjectAddSheetProperties.title )
        ]
