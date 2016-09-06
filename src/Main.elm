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
    , address : Address
    }


type alias Address =
    { street : String
    , city : String
    , zipcode : String
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


usersView : Users -> Html Msg
usersView users =
    ul [ class "mdl-list" ]
        (List.map userView users)


userView : User -> Html Msg
userView user =
    let
        address =
            user.address
    in
        li [ class "mdl-list__item mdl-list__item--three-line" ]
            [ span [ class "mdl-list__item-primary-content" ]
                [ i [ class "material-icons mdl-list__item-avatar" ] [ text "person" ]
                , span [] [ text user.name ]
                , span [ class "mdl-list__item-text-body" ]
                    [ text <|
                        address.zipcode
                            ++ " "
                            ++ address.city
                            ++ ", "
                            ++ address.street
                    ]
                ]
            , span [ class "mdl-list__item-secondary-content" ]
                [ span [ class "mdl-list__item-secondary-info" ]
                    [ text user.username
                    ]
                , i [ class "material-icons" ] [ text "star" ]
                ]
            ]


view : Model -> Html Msg
view model =
    div [ class "mdl-grid" ]
        [ div
            [ class "mdl-cell mdl-cell--6-col mdl-cell--3-offset content" ]
            [ a
                [ class "mdl-button mdl-js-button mdl-button--raised btn-more", onClick LoadUsers ]
                [ text "Load Users" ]
            , if List.isEmpty model.users then
                div [ class "mdl-typography--headline" ] [ text model.statusMsg ]
              else
                usersView model.users
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
    Decode.object4 User
        ("id" := Decode.int)
        ("name" := Decode.string)
        ("username" := Decode.string)
        ("address" := addressDecoder)


addressDecoder : Decode.Decoder Address
addressDecoder =
    Decode.object3 Address
        ("city" := Decode.string)
        ("street" := Decode.string)
        ("zipcode" := Decode.string)



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
