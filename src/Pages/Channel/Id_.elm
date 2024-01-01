module Pages.Channel.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (Channel, DaysOfWeek, Playlist, Schedule)
import Bridge exposing (ToBackend(..))
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
    , playlists : List Playlist
    , schedules : List Schedule
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params } =
    ( { channelId = params.id
      , channel = Nothing
      , playlists = []
      , schedules = []
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetChannelAndPlaylists params.id
    )



-- UPDATE


type Msg
    = GotChannelAndPlaylists Channel (List Playlist)
    | GetPlaylists
    | Schedule_UpdateHour Schedule String
    | Schedule_UpdateMinute Schedule String
    | Schedule_UpdateDaysOfWeek Schedule DaysOfWeek


updateSchedule : Schedule -> Model -> Model
updateSchedule schedule model =
    let
        schedules =
            model.schedules
                |> List.filter (\s -> s.playlistId /= schedule.playlistId)
                |> List.append [ schedule ]
    in
    { model | schedules = schedules }


update : Msg -> Model -> ( Model, Effect Msg )
update msg model =
    case msg of
        GotChannelAndPlaylists channel playlists ->
            ( { model | channel = Just channel, playlists = playlists }
            , Effect.none
            )

        Schedule_UpdateHour shedule hour ->
            case hour |> String.toInt of
                Just hour_ ->
                    ( model |> updateSchedule { shedule | hour = hour_ }
                    , Effect.none
                    )

                _ ->
                    ( model, Effect.none )

        Schedule_UpdateMinute shedule minute ->
            case minute |> String.toInt of
                Just minute_ ->
                    ( model |> updateSchedule { shedule | minute = minute_ }
                    , Effect.none
                    )

                _ ->
                    ( model, Effect.none )

        Schedule_UpdateDaysOfWeek shedule days ->
            ( model |> updateSchedule { shedule | days = days }
            , Effect.none
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
                Element.text "✓"

            else
                Element.text "X"
    in
    column []
        [ Element.Input.text []
            { onChange = \hour -> Schedule_UpdateHour schedule hour
            , placeholder = Element.Input.placeholder [] (text "Hour") |> Just
            , text = schedule.hour |> String.fromInt
            , label = text "Hour" |> Element.Input.labelLeft []
            }
        , Element.Input.text []
            { onChange = \minute -> Schedule_UpdateMinute schedule minute
            , placeholder = Element.Input.placeholder [] (text "Hour") |> Just
            , text = schedule.minute |> String.fromInt
            , label = text "Minute" |> Element.Input.labelLeft []
            }
        , row []
            [ Element.Input.checkbox []
                { onChange = \monday -> Schedule_UpdateDaysOfWeek schedule { days | monday = monday }
                , icon = tickOrUntick
                , checked = schedule.days.monday
                , label = text "Monday" |> Element.Input.labelLeft []
                }
            , Element.Input.checkbox []
                { onChange = \tuesday -> Schedule_UpdateDaysOfWeek schedule { days | tuesday = tuesday }
                , icon = tickOrUntick
                , checked = schedule.days.tuesday
                , label = text "Tuesday" |> Element.Input.labelLeft []
                }
            , Element.Input.checkbox []
                { onChange = \wednesday -> Schedule_UpdateDaysOfWeek schedule { days | wednesday = wednesday }
                , icon = tickOrUntick
                , checked = schedule.days.wednesday
                , label = text "Wednesday" |> Element.Input.labelLeft []
                }
            , Element.Input.checkbox []
                { onChange = \thursday -> Schedule_UpdateDaysOfWeek schedule { days | thursday = thursday }
                , icon = tickOrUntick
                , checked = schedule.days.thursday
                , label = text "Thursday" |> Element.Input.labelLeft []
                }
            , Element.Input.checkbox []
                { onChange = \friday -> Schedule_UpdateDaysOfWeek schedule { days | friday = friday }
                , icon = tickOrUntick
                , checked = schedule.days.friday
                , label = text "Friday" |> Element.Input.labelLeft []
                }
            , Element.Input.checkbox []
                { onChange = \saturday -> Schedule_UpdateDaysOfWeek schedule { days | saturday = saturday }
                , icon = tickOrUntick
                , checked = schedule.days.saturday
                , label = text "Saturday" |> Element.Input.labelLeft []
                }
            , Element.Input.checkbox []
                { onChange = \sunday -> Schedule_UpdateDaysOfWeek schedule { days | sunday = sunday }
                , icon = tickOrUntick
                , checked = schedule.days.sunday
                , label = text "Sunday" |> Element.Input.labelLeft []
                }
            ]
        ]


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
                    { data = model.playlists
                    , columns =
                        [ Column (Element.text "Id") (px 450) (.id >> wrappedText)
                        , Column (Element.text "Title") (px 275) (.title >> wrappedText)
                        , Column (Element.text "Description") (px 400 |> maximum 100) (.description >> wrappedText)
                        , Column
                            (Element.text "Playlists")
                            (px 100)
                            (\p -> idLink Route.Playlist__Id_ p.id "Playlists")
                        , Column
                            (Element.text "Schedule")
                            (px 100)
                            (\p ->
                                model.schedules
                                    |> List.filter (\s -> s.playlistId == p.id)
                                    |> List.head
                                    |> Maybe.withDefault
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
                        ]
                    }
                    , Element.Input.button
                        [ centerX
                        , centerY
                        , Element.Font.size 16
                        , Element.Font.bold
                        , padding 30
                        , Element.Border.color <| rgb255 128 128 128
                        , Element.Border.width 1
                        , Element.Border.innerGlow (rgb255 128 0 0) 5
                        --, Element.Border.glow (rgb255 128 0 0) 10
                        --, Element.Border.shadow { offset = (10, 10), size = 3, blur = 0.5, color = rgb255 128 0 0 }
                        --, border3d 4 Color.grey Color.black Color.white
                        --, Element.Border.color (rgb255 0 128 128) -- Typical teal color
                        --, hover [ Background.color (rgb255 0 104 104) ] -- Slightly darker on hover
                        ]
                        { label = Element.text "Get Playlists"
                        , onPress = Just GetPlaylists
                        }
                
                ]
            )
    }
