module Api.User exposing (..)

import Dict exposing (Dict)
import Env exposing (adminUsers, editorUsers)
import Html.Attributes exposing (required)
import Maybe.Extra as Maybe
import Regex


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


type alias Email =
    String


roleToString : Role -> String
roleToString role =
    case role of
        Admin ->
            "Admin"

        Editor ->
            "Editor"

        Basic ->
            "Basic"


stringToRole : String -> Role
stringToRole string =
    case string of
        "Admin" ->
            Admin

        "Editor" ->
            Editor

        _ ->
            Basic


toUser : UserFull -> User
toUser u =
    { email = u.email
    , role = u.role
    }


isAdminEmail : String -> Bool
isAdminEmail email =
    let
        adminUsers =
            Env.adminUsers |> String.split ","
    in
    adminUsers |> List.member email


isEditorEmail : String -> Bool
isEditorEmail email =
    let
        editorUsers =
            Env.editorUsers |> String.split ","
    in
    (editorUsers |> List.member email) || isAdminEmail email



-- USER VALIDATION


validateUser :
    { email : String
    , password : String
    }
    -> ( Bool, Bool )
validateUser { email, password } =
    ( validateEmail email
    , password |> (not << String.isEmpty)
    )


validateEmail : String -> Bool
validateEmail email =
    email |> Regex.contains emailRegex


emailRegex =
    Regex.fromString "[^@ \\t\\r\\n]+@[^@ \\t\\r\\n]+\\.[^@ \\t\\r\\n]+" |> Maybe.withDefault Regex.never


type Role
    = Basic
    | Editor
    | Admin


type RequiredRole
    = Require Role


checkAuthorization : RequiredRole -> Role -> Bool
checkAuthorization required role =
    case required of
        Require requiredRole ->
            case ( role, requiredRole ) of
                ( Admin, _ ) ->
                    True

                ( Editor, Admin ) ->
                    False

                ( Editor, _ ) ->
                    True

                ( Basic, Admin ) ->
                    False

                ( Basic, Editor ) ->
                    False

                ( Basic, _ ) ->
                    True


toList : Dict Email UserFull -> List User
toList users =
    List.map (\( _, user ) -> toUser user) <|
        Dict.toList <|
            users



-- For the frontend


isAdmin : Maybe User -> Bool
isAdmin maybeUser =
    maybeUser
        |> Maybe.map .role
        |> Maybe.map (checkAuthorization (Require Admin))
        |> Maybe.filter identity
        |> Maybe.isJust


isEditor : Maybe User -> Bool
isEditor maybeUser =
    maybeUser
        |> Maybe.map .role
        |> Maybe.map (checkAuthorization (Require Editor))
        |> Maybe.filter identity
        |> Maybe.isJust
