module RPC exposing (..)

import Api.PerformNow exposing (..)
import Api.YoutubeModel exposing (..)
import BackendLogging exposing (log, logCmd)
import Dict
import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E
import Lamdera exposing (..)
import LamderaRPC exposing (..)
import Types exposing (..)



-- move this to decoder folder


clientCredentialsDecoder : D.Decoder ClientCredentials
clientCredentialsDecoder =
    D.map5 ClientCredentials
        (D.field "displayName" D.string)
        (D.field "email" D.string)
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
                updatedModel =
                    { model | clientCredentials = model.clientCredentials |> Dict.insert credentials.email credentials }

                responseMsg =
                    "Stored credentials"
            in
            ( Ok <| E.string responseMsg
            , updatedModel
            , performNowWithTime (GetAccessToken credentials.email)
            )

        Err err ->
            -- Handle decoding error
            ( Err <| failWith StatusBadRequest <| "Failed to decode client credentials: " ++ D.errorToString err
            , model
            , Cmd.none
            )
