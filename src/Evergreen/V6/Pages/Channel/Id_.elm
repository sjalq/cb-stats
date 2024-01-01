module Evergreen.V6.Pages.Channel.Id_ exposing (..)

import Evergreen.V6.Api.YoutubeModel


type alias Model =
    { channelId : String
    , channel : Maybe Evergreen.V6.Api.YoutubeModel.Channel
    , playlists : List Evergreen.V6.Api.YoutubeModel.Playlist
    }


type Msg
    = GotChannelAndPlaylists Evergreen.V6.Api.YoutubeModel.Channel (List Evergreen.V6.Api.YoutubeModel.Playlist)
