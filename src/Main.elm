port module Main exposing (..)

import Html exposing (..)
import Html
import Facebook
import User
import Html.Events exposing (onClick)
import Debug exposing (log)
-- import Html.Attributes exposing (..)


-- MAIN


main : Program Never AppModel Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias AppModel =
    { userModel : User.Model
    }


initialModel : AppModel
initialModel =
    { userModel = User.initialUser
    }


init : ( AppModel, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- MESSAGE

type Msg
    = NoOp
    | Login
    | Logout
    | LoggedIn String
    | LoggedOut String
    | UserMsg User.Msg




-- PORTS

port userLoggedIn : (String -> msg) -> Sub msg
port userLoggedOut : (String -> msg) -> Sub msg



-- SUBSCRIPTIONS


subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.batch
    [ userLoggedIn LoggedIn
    , userLoggedOut LoggedOut
    ]


-- stringToMsg : String -> Msg
-- stringToMsg json =
--     UserStringMsg json
    

-- UPDATE

update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of

        LoggedIn json ->
            let
                (updatedUserModel, userCmd) =
                    User.update (User.UserLoggedIn json) model.userModel
            in
                 ({ model | userModel = updatedUserModel }, Cmd.map UserMsg userCmd) 

        LoggedOut loggedOutMsg ->
            let
                (updatedUserModel, userCmd) =
                    User.update (User.UserLoggedOut loggedOutMsg) model.userModel
            in
                 ({ model | userModel = updatedUserModel }, Cmd.none) 

        Login ->
            ( model, Facebook.login {} )

        Logout ->
            ( model, Facebook.logout {} )

        _ ->
            ( model, Cmd.none )




-- VIEW


view : AppModel -> Html Msg
view app =
    case app.userModel.loginStatus of
        User.Connected ->
            div []
                [ div [] [ text app.userModel.name ]
                , loggedInHtml
                ]
        _ ->
            div []
                [ div [] [ text app.userModel.name ]
                , loggedOutHtml
                ]


loggedInHtml : Html Msg
loggedInHtml =
    button [ onClick Logout ] [ text "Logout" ]


loggedOutHtml : Html Msg
loggedOutHtml =
    button [ onClick Login ] [ text "Login" ]
