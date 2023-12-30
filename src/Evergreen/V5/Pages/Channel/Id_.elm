module Evergreen.V5.Pages.Channel.Id_ exposing (..)

import Evergreen.V5.Api.YoutubeModel


type alias Model =
    { channelId : String
    , channel : Maybe Evergreen.V5.Api.YoutubeModel.Channel
    , playlists : List Evergreen.V5.Api.YoutubeModel.Playlist
    }


type Msg
    = GotChannelAndPlaylists Evergreen.V5.Api.YoutubeModel.Channel (List Evergreen.V5.Api.YoutubeModel.Playlist)
