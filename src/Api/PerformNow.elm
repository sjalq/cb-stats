module Api.PerformNow exposing (..)

import Task
import Time


performNowWithTime task =
    Time.now |> Task.perform task 

performNow task =
    Time.now |> Task.perform (\_ -> task)