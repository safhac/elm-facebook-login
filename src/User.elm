module User exposing (..)

import Json.Decode as Decode exposing (decodeString, field, string, at, Decoder, map2, succeed)
import Json.Encode as Encode exposing (..)
import Debug exposing (log)


-- MODEL


type alias Model =
    { name : String
    , url : String
    , loginStatus : LoginStatus
    , userType : UserType
    }


type UserType
    = Unknown
    | Client
    | Vendor
    | Runner


type LoginStatus
    = Connected
    | UnAuthorised
    | Disconnected

-- INIT


initialUser : Model
initialUser =
    { name = ""
    , url = ""
    , loginStatus = UnAuthorised
    , userType = Unknown
    }

newUser : String -> String -> Model
newUser name picture =
    { name = name
    , url = picture
    , loginStatus = Connected
    , userType = Client
    }



-- MESSAGES

type Msg
    = UserLoggedIn String
    | UserLoggedOut String




-- DECODERS

nameDecoder : String -> Result String String
nameDecoder json =
    decodeString (field "name" Decode.string) json


userDecoder : Decoder Model
userDecoder =
    map2 newUser
        (field "name" Decode.string) 
        (field "picture" <| (field "data" <| (field "url" Decode.string) )) 


setName : String -> Model -> Model
setName newName user =
  ({ user | name = newName })


loginStatusDecoder : String -> Decode.Decoder LoginStatus
loginStatusDecoder status =
    case status of
        "Connected" -> Decode.succeed Connected
        "UnAuthorised" -> Decode.succeed UnAuthorised
        "Disconnected" -> Decode.succeed Disconnected
        _ -> Decode.fail (status ++ " is not a recognized tag for login status")


userTypeDecoder : String -> Decode.Decoder UserType
userTypeDecoder userType =
  case userType of
    "Unknown" -> Decode.succeed Unknown
    "Client" -> Decode.succeed Client
    "Vendor" -> Decode.succeed Vendor
    "Runner" -> Decode.succeed Runner
    _ -> Decode.fail (userType ++ " is not a recognized tag for user type")        



-- ENCODERS

modelToValue : Model -> Encode.Value
modelToValue model =
  Encode.object
    [
        ( "name", Encode.string model.name )
        , ( "url", Encode.string model.url )
        , ( "loginStatus", loginStatusToValue model.loginStatus )
        , ( "userType", userTypeToValue model.userType )
        
    ]


loginStatusToValue : LoginStatus -> Encode.Value
loginStatusToValue status =
  case status of
    Connected -> Encode.string "Connected"
    UnAuthorised -> Encode.string "UnAuthorised"
    Disconnected -> Encode.string "Disconnected"



userTypeToValue : UserType -> Encode.Value
userTypeToValue userType =
  case userType of
    Unknown -> Encode.string "Unknown"
    Client -> Encode.string "Client"
    Vendor -> Encode.string "Vendor"
    Runner -> Encode.string "Runner"




-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserLoggedIn json ->
            -- let _ = 
            --     Debug.log "json" (decodeString userDecoder json)
            -- in
            case decodeString userDecoder json of
                (Ok userData) ->
                    ({ model | name = userData.name, url=userData.url, loginStatus=Connected }, Cmd.none)
                (Err error) ->
                    let _ = 
                        Debug.log "error" error
                    in
                    (model, Cmd.none)   
                 
        UserLoggedOut loggedOut ->
            ( initialUser , Cmd.none)
                

            

-- VIEW


-- view : Model -> Html Msg
-- view model =
--     div []
--         [ h3 [] [ text "Leaderboard page... So far" ]
--         , input
--             [ type_ "text"
--             , onInput QueryInput
--             , value model.query
--             , placeholder "Search for a runner..."
--             ]
--             []
--         ]
