module Evergreen.V71.Json.Auto.GoogleSheetsDetails exposing (..)


type alias RootProperties =
    { title : String
    }


type alias RootSheetsObjectPropertiesGridProperties =
    { columnCount : Int
    , rowCount : Int
    }


type alias RootSheetsObjectProperties =
    { gridProperties : RootSheetsObjectPropertiesGridProperties
    , index : Int
    , sheetId : Int
    , sheetType : String
    , title : String
    }


type alias RootSheetsObject =
    { properties : RootSheetsObjectProperties
    }


type alias Root =
    { properties : RootProperties
    , sheets : List RootSheetsObject
    , spreadsheetId : String
    , spreadsheetUrl : String
    }
