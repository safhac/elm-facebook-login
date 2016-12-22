module User exposing (..)

import Json.Decode as Decode exposing (decodeString, field, string, at, Decoder, map2)
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




-- DECODER

nameDecoder : String -> Result String String
nameDecoder json =
    decodeString (field "name" string) json


userDecoder : Decoder Model
userDecoder =
    map2 newUser
        (field "name" string) 
        (field "picture" <| (field "data" <| (field "url" string) )) 

setName : String -> Model -> Model
setName newName user =
  ({ user | name = newName })




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
