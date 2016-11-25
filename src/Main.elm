port module Main exposing (..)

import Html exposing (..)
import Html 
import Facebook
-- import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { userStatus : String
    }

type alias User =
  { name : String
  , imgUrl : String
  , loginStatus : String
  , userType : UserType
  }

type UserType =
    Client
    | Vendor
    | Runner 


init : ( Model, Cmd Msg )
init =
    ( Model "", Cmd.none )


-- UPDATE


type Msg
    = NoOp
    | StatusChange String
    | Login
    | Logout



port statusChange : (String -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        StatusChange string ->
            ( { model | userStatus = string }
            , Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        Login ->
            ( model, Facebook.login {})

        Logout ->
            ( model, Facebook.logout {})

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
    statusChange StatusChange



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text model.userStatus ]
        , 
        if model.userStatus == "connected" then
            button [ onClick Logout] [ text "Logout" ]
        else
            button [ onClick Login ] [ text "Login" ]
        ]