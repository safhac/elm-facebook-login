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



-- UPDATE


type Msg
    = NoOp
    | Login
    | Logout
    | StatusChange String
    | UserMsg User.Msg
    | UserStringMsg String 


port statusChange : (String -> msg) -> Sub msg

-- SUBSCRIPTIONS


subscriptions : AppModel -> Sub Msg
subscriptions model =
    statusChange StatusChange
    -- Sub.map statusChange User.UserStatusChange


stringToMsg : String -> Msg
stringToMsg json =
    UserStringMsg json
    

-- UPDATE

update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        UserMsg subMsg ->
            let
                (updatedUserModel, userCmd) =
                    User.update subMsg model.userModel
            in
                 ({ model | userModel = updatedUserModel }, Cmd.map UserMsg userCmd) 

        StatusChange json ->
            let
                (updatedUserModel, userCmd) =
                    User.update (User.UserStatusChange json) model.userModel
            in
                 ({ model | userModel = updatedUserModel }, Cmd.map UserMsg userCmd) 

        Login ->
            ( model, Facebook.login {} )

        Logout ->
            ( model, Facebook.logout {} )

        _ ->
            ( model, Cmd.none )




-- VIEW


view : AppModel -> Html Msg
view model =
    let
        user =
            model.userModel

        -- model.userStatus
    in
        div []
            [ div [] [ text user.name ]
            , case user.loginStatus of
                "connected" ->
                    loggedInHtml

                _ ->
                    loggedOutHtml
            ]


loggedInHtml : Html Msg
loggedInHtml =
    button [ onClick Logout ] [ text "Logout" ]


loggedOutHtml : Html Msg
loggedOutHtml =
    button [ onClick Login ] [ text "Login" ]
