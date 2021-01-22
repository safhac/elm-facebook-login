module User.Decoder exposing (..)

import Json.Decode as Decode exposing (Decoder, at, decodeString, field, map3, string, succeed)
import Json.Encode as Encode exposing (..)
import User.Model as User exposing (..)



-- DECODERS
--nameDecoder : String -> Result String String
--nameDecoder json =
--    decodeString (field "name" Decode.string) json


userDecoder : Decoder Model
userDecoder =
    map3 newUser
        (field "id" Decode.string)
        (field "name" Decode.string)
        (field "picture" <| (field "data" <| field "url" Decode.string))


setName : String -> Model -> Model
setName newName user =
    { user | name = newName }


loginStatusDecoder : String -> Decode.Decoder LoginStatus
loginStatusDecoder status =
    let
        _ =
            Debug.log "loginStatusDecoder " status
    in
    case status of
        "Connected" ->
            Decode.succeed Connected

        "UnAuthorised" ->
            Decode.succeed UnAuthorised

        "Disconnected" ->
            Decode.succeed Disconnected

        _ ->
            Decode.fail (status ++ " is not a recognized tag for login status")


userTypeDecoder : String -> Decode.Decoder UserType
userTypeDecoder userType =
    case userType of
        "Unknown" ->
            Decode.succeed Unknown

        "Client" ->
            Decode.succeed Client

        "Vendor" ->
            Decode.succeed Vendor

        "Runner" ->
            Decode.succeed Runner

        _ ->
            Decode.fail (userType ++ " is not a recognized tag for user type")



-- ENCODERS


modelToValue : Model -> Encode.Value
modelToValue model =
    Encode.object
        [ ( "uid", Encode.string model.uid )
        , ( "name", Encode.string model.name )
        , ( "url", Encode.string model.url )
        , ( "loginStatus", loginStatusToValue model.loginStatus )
        , ( "userType", userTypeToValue model.userType )
        ]


loginStatusToValue : LoginStatus -> Encode.Value
loginStatusToValue status =
    case status of
        Connected ->
            Encode.string "Connected"

        UnAuthorised ->
            Encode.string "UnAuthorised"

        Disconnected ->
            Encode.string "Disconnected"


userTypeToValue : UserType -> Encode.Value
userTypeToValue userType =
    case userType of
        Unknown ->
            Encode.string "Unknown"

        Client ->
            Encode.string "Client"

        Vendor ->
            Encode.string "Vendor"

        Runner ->
            Encode.string "Runner"
