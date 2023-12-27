module Evergreen.V1.Pages.Edit.MyQuestionnaires exposing (..)

import Dict
import Evergreen.V1.Api.Questionnaire


type alias Model =
    { questionnaires : Dict.Dict Evergreen.V1.Api.Questionnaire.QuestionnaireId Evergreen.V1.Api.Questionnaire.Questionnaire
    , newQuestionnaireTitle : String
    , errorMessage : Maybe String
    }


type Field
    = NewQuestionnaireTitle


type Msg
    = GotAllQuestionnaires (Dict.Dict Evergreen.V1.Api.Questionnaire.QuestionnaireId Evergreen.V1.Api.Questionnaire.Questionnaire)
    | Updated Field String
    | ClickedSubmit
    | ClickedDeleteQuestionnaire Evergreen.V1.Api.Questionnaire.QuestionnaireId
