module Evergreen.V1.Pages.Edit.MyQuestionnaires.Questionnaire_ exposing (..)

import Dict
import Evergreen.V1.Api.Questionnaire


type alias Model =
    { maybeQuestionnaire : Maybe Evergreen.V1.Api.Questionnaire.Questionnaire
    , newQuestion : String
    , newCategory : String
    , errorMessage : Maybe String
    , editingWeights : Maybe ( Evergreen.V1.Api.Questionnaire.QuestionId, Dict.Dict ( Evergreen.V1.Api.Questionnaire.QuestionId, Evergreen.V1.Api.Questionnaire.CategoryId ) String )
    }


type Field
    = NewQuestion
    | NewCategory
    | Weight Evergreen.V1.Api.Questionnaire.QuestionId Evergreen.V1.Api.Questionnaire.CategoryId


type Msg
    = GotQuestionnaire (Maybe Evergreen.V1.Api.Questionnaire.Questionnaire)
    | Updated Field String
    | ClickedSubmit Field Evergreen.V1.Api.Questionnaire.QuestionnaireId
    | ClickedDeleteQuestion Evergreen.V1.Api.Questionnaire.QuestionId Evergreen.V1.Api.Questionnaire.QuestionnaireId
    | ClickedDeleteCategory Evergreen.V1.Api.Questionnaire.CategoryId Evergreen.V1.Api.Questionnaire.QuestionnaireId
    | ToggleEditing (Maybe Evergreen.V1.Api.Questionnaire.QuestionId)
