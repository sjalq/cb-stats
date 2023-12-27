module Evergreen.V1.Pages.Submitted.Submission_ exposing (..)

import Dict
import Evergreen.V1.Api.Questionnaire


type alias Model =
    { email : String
    , errorMessage : Maybe String
    , maybeAnswerSheet : Maybe Evergreen.V1.Api.Questionnaire.AnswerSheet
    , maybeCategories : Maybe (Dict.Dict Evergreen.V1.Api.Questionnaire.CategoryId Evergreen.V1.Api.Questionnaire.Category)
    , outcomes : List Evergreen.V1.Api.Questionnaire.Outcome
    }


type Msg
    = GotAnswerSheet ( Maybe Evergreen.V1.Api.Questionnaire.AnswerSheet, Maybe (Dict.Dict Evergreen.V1.Api.Questionnaire.CategoryId Evergreen.V1.Api.Questionnaire.Category) )
    | UpdatedEmail String
    | Submitted
