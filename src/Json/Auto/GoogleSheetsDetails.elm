module Json.Auto.GoogleSheetsDetails exposing (..)

import Json.Decode
import Json.Encode


-- Required packages:
-- * elm/json


type alias Root =
    { properties : RootProperties
    , sheets : List RootSheetsObject
    , spreadsheetId : String
    , spreadsheetUrl : String
    }


type alias RootProperties =
    { title : String
    }


type alias RootSheetsObject =
    { properties : RootSheetsObjectProperties
    }


type alias RootSheetsObjectProperties =
    { gridProperties : RootSheetsObjectPropertiesGridProperties
    , index : Int
    , sheetId : Int
    , sheetType : String
    , title : String
    }


type alias RootSheetsObjectPropertiesGridProperties =
    { columnCount : Int
    , rowCount : Int
    }


rootDecoder : Json.Decode.Decoder Root
rootDecoder = 
    Json.Decode.map4 Root
        (Json.Decode.field "properties" rootPropertiesDecoder)
        (Json.Decode.field "sheets" <| Json.Decode.list rootSheetsObjectDecoder)
        (Json.Decode.field "spreadsheetId" Json.Decode.string)
        (Json.Decode.field "spreadsheetUrl" Json.Decode.string)


rootPropertiesDecoder : Json.Decode.Decoder RootProperties
rootPropertiesDecoder = 
    Json.Decode.map RootProperties
        (Json.Decode.field "title" Json.Decode.string)


rootSheetsObjectDecoder : Json.Decode.Decoder RootSheetsObject
rootSheetsObjectDecoder = 
    Json.Decode.map RootSheetsObject
        (Json.Decode.field "properties" rootSheetsObjectPropertiesDecoder)


rootSheetsObjectPropertiesDecoder : Json.Decode.Decoder RootSheetsObjectProperties
rootSheetsObjectPropertiesDecoder = 
    Json.Decode.map5 RootSheetsObjectProperties
        (Json.Decode.field "gridProperties" rootSheetsObjectPropertiesGridPropertiesDecoder)
        (Json.Decode.field "index" Json.Decode.int)
        (Json.Decode.field "sheetId" Json.Decode.int)
        (Json.Decode.field "sheetType" Json.Decode.string)
        (Json.Decode.field "title" Json.Decode.string)


rootSheetsObjectPropertiesGridPropertiesDecoder : Json.Decode.Decoder RootSheetsObjectPropertiesGridProperties
rootSheetsObjectPropertiesGridPropertiesDecoder = 
    Json.Decode.map2 RootSheetsObjectPropertiesGridProperties
        (Json.Decode.field "columnCount" Json.Decode.int)
        (Json.Decode.field "rowCount" Json.Decode.int)


encodedRoot : Root -> Json.Encode.Value
encodedRoot root = 
    Json.Encode.object
        [ ( "properties", encodedRootProperties root.properties )
        , ( "sheets", Json.Encode.list encodedRootSheetsObject root.sheets )
        , ( "spreadsheetId", Json.Encode.string root.spreadsheetId )
        , ( "spreadsheetUrl", Json.Encode.string root.spreadsheetUrl )
        ]


encodedRootProperties : RootProperties -> Json.Encode.Value
encodedRootProperties rootProperties = 
    Json.Encode.object
        [ ( "title", Json.Encode.string rootProperties.title )
        ]


encodedRootSheetsObject : RootSheetsObject -> Json.Encode.Value
encodedRootSheetsObject rootSheetsObject = 
    Json.Encode.object
        [ ( "properties", encodedRootSheetsObjectProperties rootSheetsObject.properties )
        ]


encodedRootSheetsObjectProperties : RootSheetsObjectProperties -> Json.Encode.Value
encodedRootSheetsObjectProperties rootSheetsObjectProperties = 
    Json.Encode.object
        [ ( "gridProperties", encodedRootSheetsObjectPropertiesGridProperties rootSheetsObjectProperties.gridProperties )
        , ( "index", Json.Encode.int rootSheetsObjectProperties.index )
        , ( "sheetId", Json.Encode.int rootSheetsObjectProperties.sheetId )
        , ( "sheetType", Json.Encode.string rootSheetsObjectProperties.sheetType )
        , ( "title", Json.Encode.string rootSheetsObjectProperties.title )
        ]


encodedRootSheetsObjectPropertiesGridProperties : RootSheetsObjectPropertiesGridProperties -> Json.Encode.Value
encodedRootSheetsObjectPropertiesGridProperties rootSheetsObjectPropertiesGridProperties = 
    Json.Encode.object
        [ ( "columnCount", Json.Encode.int rootSheetsObjectPropertiesGridProperties.columnCount )
        , ( "rowCount", Json.Encode.int rootSheetsObjectPropertiesGridProperties.rowCount )
        ]