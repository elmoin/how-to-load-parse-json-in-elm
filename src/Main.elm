module Main exposing (..)

import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode exposing ((:=))
import Task


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
    | UsersSuccess Users
    | UsersError Http.Error


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadUsers ->
            ( { model | statusMsg = "...loading ..." }, getUsers )

        UsersSuccess users ->
            ( { model | users = users }, Cmd.none )

        UsersError error ->
            ( { model | statusMsg = "error trying to load users" }, Cmd.none )



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



-- HTTP


getUsers : Cmd Msg
getUsers =
    Http.get usersDecoder "./users.json"
        |> Task.perform UsersError UsersSuccess


usersDecoder : Decode.Decoder Users
usersDecoder =
    Decode.list userDecoder


userDecoder : Decode.Decoder User
userDecoder =
    Decode.object3 User
        ("id" := Decode.int)
        ("name" := Decode.string)
        ("username" := Decode.string)



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
