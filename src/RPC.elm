module RPC exposing (..)

import Backend
import BackendLogging exposing (log, logCmd)
import Dict
import Env
import Http
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E
import Lamdera exposing (..)
import LamderaRPC exposing (..)
import Types exposing (..)
import Api.ClientCredentials exposing (..)
import Shared.Msg exposing (Msg(..))

-- move this to decoder folder

clientCredentialsDecoder : D.Decoder ClientCredentials
clientCredentialsDecoder =
    D.map3 ClientCredentials
        (D.field "accessToken" D.string)
        (D.field "refreshToken" D.string)
        (D.field "timestamp" D.int)


lamdera_handleEndpoints : E.Value -> HttpRequest -> BackendModel -> ( LamderaRPC.RPCResult, BackendModel, Cmd BackendMsg )
lamdera_handleEndpoints rawReq args model =
    case args.endpoint of
        "storeClientCredentials" ->
            LamderaRPC.handleEndpointJsonRaw (storeClientCredentialsEndpoint rawReq) args model
        _ ->
            ( LamderaRPC.resultWith LamderaRPC.StatusBadRequest [] <| BodyString <| "Unknown endpoint " ++ args.endpoint, model, Cmd.none )

-- Endpoint function
storeClientCredentialsEndpoint : E.Value -> SessionId -> BackendModel -> Headers -> E.Value -> ( Result RPCFailure E.Value, BackendModel, Cmd BackendMsg )
storeClientCredentialsEndpoint rawReq _ model headers jsonArg =
    case D.decodeValue clientCredentialsDecoder jsonArg of
        Ok credentials ->
            -- Process and store credentials here, possibly updating the model and logging
            -- Placeholder for processing and updating model:
            let
                _ = Debug.log "Credentials" credentials
                updatedModel = { model | clientCredentials = Just credentials}
                responseMsg = "Stored credentials"
            in
            ( Ok <| E.string responseMsg, updatedModel, Lamdera.broadcast (NewClientCredentials credentials ))

        Err err ->
            -- Handle decoding error
            ( Err <| failWith StatusBadRequest <| "Failed to decode client credentials: " ++ D.errorToString err
            , model
            , Cmd.none
            )