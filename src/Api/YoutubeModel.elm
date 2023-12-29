module Api.YoutubeModel exposing (..)

type alias ClientCredentials =
    { displayName : String
    , email : String
    , accessToken : String
    , refreshToken : String
    , timestamp : Int
    }

type alias Channel =
    { id : String
    , title : String
    , description : String
    , customUrl : String
    }

type alias ChannelAssociation =
    { email : String
    , channelId : String
    }

type alias Playlist =
    { id : String
    , title : String
    , description : String
    , channelId : String
    }