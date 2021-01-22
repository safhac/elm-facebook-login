module App.View exposing (..)

import App.Model exposing (..)
import App.Update as Update exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import User.Model as User exposing (..)



-- VIEW


view : AppModel -> Html Update.Msg
view app =
    case app.userModel.loginStatus of
        User.Connected ->
            div []
                [ div [] [ text app.userModel.name ]
                , loggedInHtml app.userModel.url
                ]

        _ ->
            div []
                [ div [] [ text app.userModel.name ]
                , loggedOutHtml
                ]


loggedInHtml : String -> Html Update.Msg
loggedInHtml pic =
    div []
        [ img [ src pic ] []
        , button [ onClick Logout ] [ text "Logout" ]
        ]


loggedOutHtml : Html Update.Msg
loggedOutHtml =
    button [ onClick Login ] [ text "Login" ]
