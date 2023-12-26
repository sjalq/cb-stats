module BackendLogging exposing (log, logCmd)

import Api.Logging exposing (LogLevel(..))
import Task
import Time
import Types exposing (BackendMsg(..))


logCmd : String -> LogLevel -> Cmd BackendMsg
logCmd msg lvl =
    Task.perform (Log_ msg lvl) Time.now


log : String -> LogLevel -> ( a, Cmd BackendMsg ) -> ( a, Cmd BackendMsg )
log msg lvl ( model, cmd ) =
    ( model, Cmd.batch [ cmd, logCmd msg lvl ] )