module Evergreen.V1.Pages.Example exposing (..)

import Evergreen.V1.Api.ClientCredentials


type alias Model =
    { clientCredentials : List Evergreen.V1.Api.ClientCredentials.ClientCredentials
    }


type Msg
    = GotCredentials (List Evergreen.V1.Api.ClientCredentials.ClientCredentials)
