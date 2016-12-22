module User exposing (..)

import Json.Decode as Decode exposing (decodeString, field, string)
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



-- MESSAGES

type Msg
    = UserLoggedIn String
    | UserLoggedOut String




-- DECODER

nameDecoder : String -> Result String String
nameDecoder js =
    decodeString (field "name" string) js


setName : String -> Model -> Model
setName newName user =
  ({ user | name = newName })




-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserLoggedIn json ->
            case nameDecoder json of
                (Ok newName) ->
                    let _ = 
                        Debug.log "name" newName
                    in
                        ({ model | name = newName, loginStatus=Connected }, Cmd.none)
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
