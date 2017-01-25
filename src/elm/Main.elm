port module Main exposing (..)

import App.Model exposing (Model)
import App.Update exposing (init, update, Msg)
import App.View exposing (view)

import Facebook


-- MAIN

main : Program (Maybe Encode.Value) AppModel Msg
main =
    Html.programWithFlags
        { init = init
        , view = view
        , update = updateWithStorage
        , subscriptions = subscriptions
        }


-- SUBSCRIPTIONS

subscriptions : AppModel -> Sub Msg
subscriptions model =
    Sub.batch
        [ userLoggedIn LoggedIn
        , userLoggedOut LoggedOut
        ]




-- PORTS


port userLoggedIn : (String -> msg) -> Sub msg


port userLoggedOut : (String -> msg) -> Sub msg


port setStorage : Encode.Value -> Cmd msg










