module Gen.Route exposing
    ( Route(..)
    , fromUrl
    , toHref
    )

import Gen.Params.Admin
import Gen.Params.End
import Gen.Params.Example
import Gen.Params.Home_
import Gen.Params.Log
import Gen.Params.Login
import Gen.Params.NotFound
import Gen.Params.Register
import Gen.Params.Channel.Id_
import Gen.Params.Ga.Email_
import Gen.Params.Playlist.Id_
import Gen.Params.Video.Id_
import Url exposing (Url)
import Url.Parser as Parser exposing ((</>), Parser)


type Route
    = Admin
    | End
    | Example
    | Home_
    | Log
    | Login
    | NotFound
    | Register
    | Channel__Id_ { id : String }
    | Ga__Email_ { email : String }
    | Playlist__Id_ { id : String }
    | Video__Id_ { id : String }


fromUrl : Url -> Route
fromUrl =
    Parser.parse (Parser.oneOf routes) >> Maybe.withDefault NotFound


routes : List (Parser (Route -> a) a)
routes =
    [ Parser.map Home_ Gen.Params.Home_.parser
    , Parser.map Admin Gen.Params.Admin.parser
    , Parser.map End Gen.Params.End.parser
    , Parser.map Example Gen.Params.Example.parser
    , Parser.map Log Gen.Params.Log.parser
    , Parser.map Login Gen.Params.Login.parser
    , Parser.map NotFound Gen.Params.NotFound.parser
    , Parser.map Register Gen.Params.Register.parser
    , Parser.map Ga__Email_ Gen.Params.Ga.Email_.parser
    , Parser.map Channel__Id_ Gen.Params.Channel.Id_.parser
    , Parser.map Playlist__Id_ Gen.Params.Playlist.Id_.parser
    , Parser.map Video__Id_ Gen.Params.Video.Id_.parser
    ]


toHref : Route -> String
toHref route =
    let
        joinAsHref : List String -> String
        joinAsHref segments =
            "/" ++ String.join "/" segments
    in
    case route of
        Admin ->
            joinAsHref [ "admin" ]
    
        End ->
            joinAsHref [ "end" ]
    
        Example ->
            joinAsHref [ "example" ]
    
        Home_ ->
            joinAsHref []
    
        Log ->
            joinAsHref [ "log" ]
    
        Login ->
            joinAsHref [ "login" ]
    
        NotFound ->
            joinAsHref [ "not-found" ]
    
        Register ->
            joinAsHref [ "register" ]
    
        Channel__Id_ params ->
            joinAsHref [ "channel", params.id ]
    
        Ga__Email_ params ->
            joinAsHref [ "ga", params.email ]
    
        Playlist__Id_ params ->
            joinAsHref [ "playlist", params.id ]
    
        Video__Id_ params ->
            joinAsHref [ "video", params.id ]

