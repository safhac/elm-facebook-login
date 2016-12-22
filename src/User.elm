module User exposing (..)

import Json.Decode as Decode exposing (decodeString, field, string)
import Debug exposing (log)

-- MODEL


type alias Model =
    { name : String
    , url : String
    , loginStatus : String
    , userType : UserType
    }


type UserType
    = Annonymous
    | Client
    | Vendor
    | Runner



-- INIT


initialUser : Model
initialUser =
    { name = "anonymous"
    , url = ""
    , loginStatus = "unknown"
    , userType = Annonymous
    }


-- Messages

type Msg
    = UserStatusChange String




nameDecoder : String -> Result String String
nameDecoder js =
    decodeString (field "name" string) js


setName : String -> Model -> Model
setName newName user =
  ({ user | name = newName })


-- update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserStatusChange json ->
            case nameDecoder json of
                (Ok newName) ->
                    let _ = 
                        Debug.log "name" newName
                    in
                        ({ model | name = newName, loginStatus="connected" }, Cmd.none)
                (Err error) ->
                    (model, Cmd.none)
                

            
            -- ( { model
            --     | name = toString (model.name)
            --     , url = toString (model.name)
            --     , loginStatus = "connected"
            --   }
            -- , Cmd.none
            -- )



-- view
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
