module Pages.Channel.Id_ exposing (Model, Msg(..), page)

import Api.YoutubeModel exposing (Channel, Playlist, Schedule)
import Bridge exposing (ToBackend(..))
import Dict exposing (..)
import Effect exposing (Effect)
import Element exposing (..)
import Element.Border
import Element.Font exposing (..)
import Element.Input
import Gen.Params.Channel.Id_ exposing (Params)
import Gen.Route as Route
import Iso8601
import Lamdera exposing (sendToBackend)
import MoreDict
import Page
import Request
import Set
import Shared
import Styles.Colors
import Time
import UI.Helpers exposing (..)
import View exposing (View)
import Bridge exposing (ToBackend(..))


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
    , latestVideos : Dict String Int
    , schedules : Dict String Schedule
    , tmpCompetitors : Dict String String
    }


init : Request.With Params -> ( Model, Effect Msg )
init { params } =
    ( { channelId = params.id
      , channel = Nothing
      , playlists = Dict.empty
      , latestVideos = Dict.empty
      , schedules = Dict.empty
      , tmpCompetitors = Dict.empty
      }
    , Effect.fromCmd <| sendToBackend <| AttemptGetChannelAndPlaylists params.id
    )



-- UPDATE


type Msg
    = GotChannelAndPlaylists Channel (Dict String Playlist) (Dict String Int) (Dict String Schedule)
    | GetPlaylists
    | Schedule_UpdateSchedule Schedule
    | MonitorPlaylist Playlist Bool
    | Competitors Playlist String


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
        GotChannelAndPlaylists channel playlists latestVideos schedules ->
            ( { model
                | channel =
                    Just channel
                , playlists = playlists
                , latestVideos = latestVideos
                , schedules = schedules
                , tmpCompetitors = playlists |> Dict.map (\_ p -> p.competitorIds |> Set.toList |> String.join ",")
              }
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

        MonitorPlaylist playlist monitor ->
            let
                newPlaylist =
                    { playlist | monitor = monitor }
            in
            ( { model | playlists = model.playlists |> Dict.insert playlist.id newPlaylist }
            , Effect.fromCmd <| sendToBackend <| UpdatePlaylist newPlaylist
            )

        Competitors playlist competitors ->
            let
                newPlaylist =
                    { playlist
                        | competitorIds = 
                            competitors 
                            |> String.split "," 
                            |> List.map String.trim
                            |> List.filter (\c -> c /= "")
                            |> Set.fromList
                    }
            in
            ( { model
                | playlists = model.playlists |> Dict.insert playlist.id newPlaylist
                , tmpCompetitors = model.tmpCompetitors |> Dict.insert playlist.id competitors
              }
            , Effect.fromCmd <| sendToBackend <| UpdatePlaylist newPlaylist
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


tickOrUntick : Bool -> Element Msg
tickOrUntick ticked =
    if ticked then
        Element.text "✅"

    else
        Element.text "❌"


scheduleComponent schedule =
    let
        days =
            schedule.days

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
            [ Element.Input.text [ width <| Element.minimum 40 (px 10), paddingXY 3 3, centerX, centerY ]
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
                [ Element.el titleStyle (Element.text <| "Playlists associated to channel:")
                , Element.el
                    (titleStyle ++ [ Element.Font.color Styles.Colors.skyBlue ])
                    (Element.text <| (model.channel |> Maybe.map .title |> Maybe.withDefault "impossibruu!"))
                , Element.table
                    tableStyle
                    { data =
                        let
                            x =
                                model.playlists
                                    |> MoreDict.rightOuterJoin model.latestVideos
                                    |> Dict.values
                                    |> List.map
                                        (\( latestVideo, p ) ->
                                            { id = p.id
                                            , title = p.title
                                            , description = p.description
                                            , channelId = p.channelId
                                            , monitor = p.monitor
                                            , latestVideo = latestVideo |> Maybe.withDefault 0
                                            , p = p
                                            }
                                        )
                                    |> List.sortBy
                                        (\p ->
                                            ( if p.monitor then
                                                0

                                              else
                                                1
                                            , -p.latestVideo
                                            , p.title
                                            )
                                        )
                        in
                        x
                    , columns =
                        [ Column (columnHeader "Id") (px 250) (.id >> wrappedText)
                        , Column (columnHeader "Title") (px 275) (.title >> wrappedText)
                        , Column (columnHeader "Description") (px 400 |> maximum 100) (.description >> String.left 200 >> wrappedText)
                        , Column
                            (columnHeader "Monitor")
                            (px 100)
                            (\p ->
                                Element.Input.checkbox [ paddingXY 35 35, width fill, centerX, centerY ]
                                    { onChange = \c -> MonitorPlaylist p.p c
                                    , icon = tickOrUntick
                                    , checked = p.monitor
                                    , label = "Monitor" |> Element.Input.labelHidden
                                    }
                                    |> UI.Helpers.wrappedCell
                            )
                        , Column (columnHeader "Latest Video") (px 200) (.latestVideo >> Time.millisToPosix >> Iso8601.fromTime >> String.left 16 >> wrappedText)
                        -- , Column
                        --     (columnHeader "Competitor Channel Handles")
                        --     (px 200)
                        --     (\p ->
                        --         Element.Input.multiline
                        --             [ height (px 100), Element.Border.color Styles.Colors.skyBlue, Element.Border.width 1, paddingXY 5 5 ]
                        --             { onChange = Competitors p.p
                        --             , text = 
                        --                 if (model.tmpCompetitors |> Dict.get p.id |> Maybe.withDefault "") == "" then
                        --                     p.p.competitorHandles |> Set.toList |> String.join ","
                        --                 else
                        --                     model.tmpCompetitors |> Dict.get p.id |> Maybe.withDefault ""
                        --             , placeholder = Nothing
                        --             , label = Element.Input.labelHidden "Competitors"
                        --             , spellcheck = False
                        --             }
                        --     )
                        , Column 
                            (columnHeader "Competitor Ids")
                            (px 200)
                            (\p ->
                                Element.Input.multiline
                                    [ height (px 100), Element.Border.color Styles.Colors.skyBlue, Element.Border.width 1, paddingXY 5 5 ]
                                    { onChange = Competitors p.p
                                    , text = 
                                        if (model.tmpCompetitors |> Dict.get p.id |> Maybe.withDefault "") == "" then
                                            p.p.competitorIds |> Set.toList |> String.join ","
                                        else
                                            model.tmpCompetitors |> Dict.get p.id |> Maybe.withDefault ""
                                    , placeholder = Nothing
                                    , label = Element.Input.labelHidden "Competitors"
                                    , spellcheck = False
                                    }
                            )
                        , Column
                            (Element.text "")
                            (px 100)
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
