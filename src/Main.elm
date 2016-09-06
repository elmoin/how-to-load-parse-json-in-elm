module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL


type alias Model =
    { users : Users
    , statusMsg : String
    }


type alias Users =
    List User


type alias User =
    { id : Int
    , name : String
    , username : String
    }



-- UPDATE


type Msg
    = LoadUsers


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "mdl-grid" ]
        [ div
            [ class "mdl-cell mdl-cell--6-col mdl-cell--3-offset content" ]
            [ a
                [ class "mdl-button mdl-js-button mdl-button--raised btn-more", onClick LoadUsers ]
                [ text "Load Users" ]
            ]
        ]



-- Main


init : ( Model, Cmd Msg )
init =
    ( Model [] "", Cmd.none )


main : Program Never
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
