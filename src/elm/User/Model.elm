module User.Model exposing (..)

-- import Json.Decode as Decode exposing (decodeString, field, string, at, Decoder, map3, succeed)
-- import Json.Encode as Encode exposing (..)
-- import Debug exposing (log)
-- MODEL


type alias Model =
    { uid : String
    , name : String
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
    { uid = ""
    , name = ""
    , url = ""
    , loginStatus = UnAuthorised
    , userType = Unknown
    }


newUser : String -> String -> String -> Model
newUser uid name picture =
    { uid = uid
    , name = name
    , url = picture
    , loginStatus = Connected
    , userType = Client
    }



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
