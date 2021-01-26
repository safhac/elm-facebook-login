port module App.Update exposing (Msg(..), init, update, updateWithStorage)

import App.Model exposing (AppModel, initialModel)
import Facebook.Port as Facebook
import Json.Decode as Decode exposing (..)
import Json.Encode as Encode exposing (..)
import User.Decoder exposing (loginStatusDecoder, modelToValue, userTypeDecoder)
import User.Model as User exposing (..)
import User.Update as UserUpdate exposing (..)



-- MESSAGE


type Msg
    = NoOp
    | Login
    | Logout
    | LoggedIn String
    | LoggedOut String
    | UserMsg UserUpdate.Msg



-- INIT


init : Maybe Encode.Value -> ( AppModel, Cmd Msg )
init savedModel =
    case savedModel of
        Just value ->
            let
                _ =
                    Debug.log "init value " value
            in
            ( Maybe.withDefault initialModel (Decode.decodeValue modelDecoder value |> resultToMaybe)
            , Cmd.none
            )

        _ ->
            ( initialModel
            , Cmd.none
            )



-- PORT


port setStorage : Encode.Value -> Cmd msg



-- UPDATE


updateWithStorage : Msg -> AppModel -> ( AppModel, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model

        _ =
            Debug.log "updateWithStorage " msg
    in
    ( newModel
    , Cmd.batch [ setStorage (modelToValue newModel.userModel), cmds ]
    )


update : Msg -> AppModel -> ( AppModel, Cmd Msg )
update msg model =
    case msg of
        LoggedIn json ->
            let
                ( updatedUserModel, userCmd ) =
                    UserUpdate.update (UserUpdate.UserLoggedIn json) model.userModel

                _ =
                    Debug.log "update LoggedIn " json
            in
            ( { model | userModel = updatedUserModel }, Cmd.map UserMsg userCmd )

        LoggedOut loggedOutMsg ->
            let
                ( updatedUserModel, userCmd ) =
                    UserUpdate.update (UserLoggedOut loggedOutMsg) model.userModel

                _ =
                    Debug.log "update LoggedOut " loggedOutMsg
            in
            ( { model | userModel = updatedUserModel }, Cmd.none )

        Login ->
            let
                _ =
                    Debug.log "update Login " Login
            in
            ( model, Facebook.login {} )

        Logout ->
            let
                _ =
                    Debug.log "update Login " Login
            in
            ( model, Facebook.logout {} )

        _ ->
            ( model, Cmd.none )



-- DECODER
-- Decode the saved model from localstorage


modelDecoder : Decode.Decoder AppModel
modelDecoder =
    Decode.map5 modelConstructor
        (field "uid" Decode.string)
        (field "name" Decode.string)
        (field "url" Decode.string)
        (field "loginStatus" Decode.string |> andThen loginStatusDecoder)
        (field "userType" Decode.string |> andThen userTypeDecoder)



-- HELPERS
-- helper to construct model from the decoded object


modelConstructor : String -> String -> String -> User.LoginStatus -> User.UserType -> AppModel
modelConstructor uid name picture status userType =
    AppModel
        { uid = uid
        , name = name
        , url = picture
        , loginStatus = status
        , userType = userType
        }



-- Maybe object helper


resultToMaybe : Result Error AppModel -> Maybe AppModel
resultToMaybe result =
    case result of
        Result.Ok model ->
            Just model

        Result.Err error ->
            Nothing
