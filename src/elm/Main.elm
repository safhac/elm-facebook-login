port module Main exposing (..)

import App.Model exposing (AppModel)
import App.Update as Update exposing (Msg, init, update, updateWithStorage)
import App.View exposing (view)
import Browser
import Json.Encode as Encode exposing (Value)



-- MAIN


main : Program (Maybe Encode.Value) AppModel Update.Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = updateWithStorage
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : AppModel -> Sub Update.Msg
subscriptions model =
    Sub.batch
        [ userLoggedIn Update.LoggedIn
        , userLoggedOut Update.LoggedOut
        ]



-- PORTS


port userLoggedIn : (String -> msg) -> Sub msg


port userLoggedOut : (String -> msg) -> Sub msg
