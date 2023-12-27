module Evergreen.V1.Pages.Edit.MyCategories.Questionnaire_.Category_ exposing (..)

import Evergreen.V1.Api.Questionnaire


type alias Model =
    { maybeQuestionnaireId : Maybe Evergreen.V1.Api.Questionnaire.QuestionnaireId
    , maybeCategory : Maybe Evergreen.V1.Api.Questionnaire.Category
    , updatedOutcomes : Evergreen.V1.Api.Questionnaire.Outcomes
    , errorMessage : Maybe String
    , updatedText : Bool
    }


type Level
    = VeryLow
    | Low
    | Medium
    | High
    | VeryHigh


type Msg
    = GotCategory (Maybe Evergreen.V1.Api.Questionnaire.Category)
    | UpdatedProblemStatement Level String
    | UpdatedSolution Level String
    | ClickedSubmit
