port module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String


main =
    App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { userStatus : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )


-- UPDATE


type Msg
    = NoOp
    | StatusChange String


port statusChange : (String -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StatusChange string ->
            ( { model | userStatus = string }
            , Cmd.none )

        NoOp ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    statusChange StatusChange



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.userStatus ]
        , button [ ] [ text "Check" ]
        ]
