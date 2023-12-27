module Evergreen.V1.Api.Questionnaire exposing (..)

import Dict
import Lamdera


type alias QuestionnaireId =
    String


type alias QuestionId =
    String


type alias Question =
    { questionId : QuestionId
    , text : String
    , created : Int
    }


type alias CategoryId =
    String


type alias Outcome =
    { problemStatement : String
    , solution : String
    }


type alias Outcomes =
    { veryLow : Outcome
    , low : Outcome
    , medium : Outcome
    , high : Outcome
    , veryHigh : Outcome
    }


type alias Category =
    { categoryId : CategoryId
    , title : String
    , outcomes : Maybe Outcomes
    , created : Int
    }


type alias Weight =
    Float


type alias Questionnaire =
    { questionnaireId : QuestionnaireId
    , title : String
    , questions : Dict.Dict QuestionId Question
    , categories : Dict.Dict CategoryId Category
    , categoryWeights : Dict.Dict ( QuestionId, CategoryId ) Weight
    , created : Int
    }


type alias AnswerSheetId =
    String


type alias AnswerId =
    Int


type AnswerValue
    = StronglyDisagree
    | Disagree
    | Neutral
    | Agree
    | StronglyAgree
    | Unanswered


type alias Answer =
    { answerId : AnswerId
    , questionId : QuestionId
    , value : AnswerValue
    }


type alias AnswerSheet =
    { answerSheetId : AnswerSheetId
    , questionnaireId : QuestionnaireId
    , sessionId : Lamdera.SessionId
    , created : Int
    , answers : List Answer
    , email : Maybe String
    , scores : List ( CategoryId, Float )
    }
