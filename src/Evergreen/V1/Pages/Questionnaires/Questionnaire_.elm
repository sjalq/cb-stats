module Evergreen.V1.Pages.Questionnaires.Questionnaire_ exposing (..)

import Dict
import Evergreen.V1.Api.Questionnaire
import Time


type alias Model =
    { maybeQuestionnaire :
        Maybe
            { title : String
            , questionnaireId : Evergreen.V1.Api.Questionnaire.QuestionnaireId
            , questions : Dict.Dict Evergreen.V1.Api.Questionnaire.QuestionId Evergreen.V1.Api.Questionnaire.Question
            }
    , answers : Dict.Dict Evergreen.V1.Api.Questionnaire.QuestionId Evergreen.V1.Api.Questionnaire.AnswerValue
    , errorMessage : Maybe String
    , currentQuestion : Int
    , currentTimer : Int
    , timesUp : Bool
    , lastQuestion : Bool
    , numberOfQuestions : Int
    , started : Bool
    }


type Msg
    = GotQuestionnaire
        (Maybe
            { title : String
            , questionnaireId : Evergreen.V1.Api.Questionnaire.QuestionnaireId
            , questions : Dict.Dict Evergreen.V1.Api.Questionnaire.QuestionId Evergreen.V1.Api.Questionnaire.Question
            }
        )
    | AnsweredQuestion Evergreen.V1.Api.Questionnaire.QuestionId Evergreen.V1.Api.Questionnaire.AnswerValue
    | ClickedSubmit Evergreen.V1.Api.Questionnaire.QuestionId
    | GotSuccessfulSubmission Evergreen.V1.Api.Questionnaire.AnswerSheetId
    | Tick Time.Posix
    | AdvanceQuestion Evergreen.V1.Api.Questionnaire.QuestionId
    | ClickedStart
