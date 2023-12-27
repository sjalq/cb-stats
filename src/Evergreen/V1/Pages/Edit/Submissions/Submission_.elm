module Evergreen.V1.Pages.Edit.Submissions.Submission_ exposing (..)

import Dict
import Evergreen.V1.Api.Questionnaire


type alias Model =
    { maybeAnswerSheets : Maybe (Dict.Dict Evergreen.V1.Api.Questionnaire.AnswerSheetId Evergreen.V1.Api.Questionnaire.AnswerSheet)
    , categories : Dict.Dict Evergreen.V1.Api.Questionnaire.CategoryId Evergreen.V1.Api.Questionnaire.Category
    }


type Msg
    = GotAnswerSheetsAndCategories ( Dict.Dict Evergreen.V1.Api.Questionnaire.AnswerSheetId Evergreen.V1.Api.Questionnaire.AnswerSheet, Maybe (Dict.Dict Evergreen.V1.Api.Questionnaire.CategoryId Evergreen.V1.Api.Questionnaire.Category) )
