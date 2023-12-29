module Gen.Params.Ga.Email_ exposing (Params, parser)

import Url.Parser as Parser exposing ((</>), Parser)


type alias Params =
    { email : String }


parser =
    Parser.map Params (Parser.s "ga" </> Parser.string)

