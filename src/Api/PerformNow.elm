module Api.PerformNow exposing (..)

import Task
import Time


performNow task =
    Time.now |> Task.perform task 
