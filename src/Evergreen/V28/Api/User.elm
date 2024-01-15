module Evergreen.V28.Api.User exposing (..)


type alias Email =
    String


type Role
    = Basic
    | Editor
    | Admin


type alias User =
    { email : Email
    , role : Role
    }


type alias UserFull =
    { email : Email
    , role : Role
    , passwordHash : String
    , salt : String
    }
