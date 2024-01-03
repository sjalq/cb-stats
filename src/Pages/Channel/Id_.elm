module Pages.Channel.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (Channel, DaysOfWeek, Playlist, Schedule)
import Bridge exposing (ToBackend(..))
import Dict exposing (..)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border
import Element.Font exposing (..)
import Element.Input
import Gen.Params.Channel.Id_ exposing (Params)
import Gen.Route as Route
import Html.Attributes
import Lamdera exposing (sendToBackend)
import Page
import Request
import Shared
import UI.Helpers exposing (..)
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init req
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { channelId : String
    , channel : Maybe Channel
    , playlists : Dict String Playlist
    , schedules : Dict String Schedule
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params } =
    ( { channelId = params.id
      , channel = Nothing
      , playlists = Dict.empty
      , schedules = Dict.empty
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetChannelAndPlaylists params.id
    )



-- UPDATE


type Msg
    = GotChannelAndPlaylists Channel (Dict String Playlist) (Dict String Schedule)
    | GetPlaylists
    | Schedule_UpdateSchedule Schedule


schedule_selectDaysOfWeek dayCaseInsesitive schedule selected =
    let
        days =
            schedule.days

        day =
            dayCaseInsesitive |> String.toLower |> String.trim
    in
    case day of
        "monday" ->
            { schedule | days = { days | monday = selected } }

        "tuesday" ->
            { schedule | days = { days | tuesday = selected } }

        "wednesday" ->
            { schedule | days = { days | wednesday = selected } }

        "thursday" ->
            { schedule | days = { days | thursday = selected } }

        "friday" ->
            { schedule | days = { days | friday = selected } }

        "saturday" ->
            { schedule | days = { days | saturday = selected } }

        "sunday" ->
            { schedule | days = { days | sunday = selected } }

        _ ->
            schedule


schedule_updateHour schedule hour =
    case hour |> String.toInt of
        Just hour_ ->
            if hour_ < 0 || hour_ > 23 then
                { schedule | hour = 0 }

            else
                { schedule | hour = hour_ }

        _ ->
            schedule


schedule_updateMinute schedule minute =
    case minute |> String.toInt of
        Just minute_ ->
            if minute_ < 0 || minute_ > 59 then
                { schedule | minute = 0 }

            else
                { schedule | minute = minute_ }

        _ ->
            schedule


updateSchedule : Schedule -> Model -> Model
updateSchedule schedule model =
    let
        schedules =
            model.schedules
                |> Dict.insert schedule.playlistId schedule
    in
    { model | schedules = schedules }


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotChannelAndPlaylists channel playlists schedules ->
            ( { model | channel = Just channel, playlists = playlists, schedules = schedules }
            , Effect.none
            )

        Schedule_UpdateSchedule newSchedule ->
            ( model |> updateSchedule newSchedule
            , Effect.fromCmd <| sendToBackend <| UpdateSchedule newSchedule
            )

        GetPlaylists ->
            ( model
            , Effect.fromCmd <| sendToBackend <| FetchPlaylistsFromYoutube model.channelId
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


scheduleComponent : Schedule -> Element Msg
scheduleComponent schedule =
    let
        days =
            schedule.days

        tickOrUntick : Bool -> Element Msg
        tickOrUntick ticked =
            if ticked then
                Element.text "✅"

            else
                Element.text "❌"

        dayCheckbox label checked =
            let
                newSchedule =
                    schedule_selectDaysOfWeek label schedule
            in
            Element.Input.checkbox [ paddingXY 5 5, width fill, centerX ]
                { onChange = \c -> Schedule_UpdateSchedule (newSchedule c)
                , icon = tickOrUntick
                , checked = checked
                , label = text label |> Element.Input.labelLeft []
                }
    in
    column [ Element.width fill, Element.paddingXY 10 10 ]
        [ row [ Element.width fill ]
            [ Element.Input.text [ width <| Element.minimum 40 (px 10), paddingXY 3 3, centerX, centerY  ]
                { onChange = \hour -> Schedule_UpdateSchedule (schedule_updateHour schedule hour)
                , placeholder = Nothing
                , text = schedule.hour |> String.fromInt
                , label = text "Hour" |> Element.Input.labelLeft []
                }
            , Element.Input.text [ width <| Element.minimum 40 (px 10), paddingXY 3 3 ]
                { onChange = \minute -> Schedule_UpdateSchedule (schedule_updateMinute schedule minute)
                , placeholder = Nothing
                , text = schedule.minute |> String.fromInt
                , label = text "Minute" |> Element.Input.labelLeft []
                }
            ]
        , column [ Element.width fill ]
            [ row [ Element.width fill, centerX ]
                [ dayCheckbox "Monday" days.monday
                , dayCheckbox "Tuesday" days.tuesday
                ]
            , row [ Element.width fill, centerX ]
                [ dayCheckbox "Wednesday" days.wednesday
                , dayCheckbox "Thursday" days.thursday
                ]
            , row [ Element.width fill, centerX ]
                [ dayCheckbox "Friday" days.friday
                , dayCheckbox "Saturday" days.saturday
                , dayCheckbox "Sunday" days.sunday
                ]
            ]

        --|> UI.Helpers.wrappedCell
        ]
        |> UI.Helpers.wrappedCell



-- |> UI.Helpers.wrappedCell


view : Model -> View Msg
view model =
    { title = "Playlists for " ++ model.channelId
    , body =
        el
            [ centerX
            , centerY
            ]
            (Element.column
                []
                [ Element.text <| (model.channel |> Maybe.map .title |> Maybe.withDefault "ihmpossibru!")
                , Element.table
                    tableStyle
                    { data = model.playlists |> Dict.values |> List.sortBy .title
                    , columns =
                        [ Column (columnHeader "Id") (px 450) (.id >> wrappedText)
                        , Column (columnHeader "Title") (px 275) (.title >> wrappedText)
                        , Column (columnHeader "Description") (px 400 |> maximum 100) (.description >> wrappedText)
                        , Column
                            (columnHeader "Schedule")
                            (px 350)
                            (\p ->
                                model.schedules
                                    |> Dict.get p.id
                                    |> Maybe.withDefault
                                        -- also acts to initialize one if none exists
                                        { playlistId = p.id
                                        , hour = 0
                                        , minute = 0
                                        , days =
                                            { monday = False
                                            , tuesday = False
                                            , wednesday = False
                                            , thursday = False
                                            , friday = False
                                            , saturday = False
                                            , sunday = False
                                            }
                                        }
                                    |> scheduleComponent
                            )
                        ,Column 
                            (Element.text "")
                            (px 200)
                            (\c ->
                                linkButton
                                    "Videos"
                                <|
                                    Route.toHref <|
                                        Route.Playlist__Id_
                                            { id = c.id }
                            )
                        ]
                    }
                , el
                    ([ Element.width (px 200), paddingXY 10 10 ] ++ centerCenter)
                    (msgButton "Get Playlists" (Just GetPlaylists))
                ]
            )
    }
