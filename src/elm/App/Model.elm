module App.Model exposing (initialModel, AppModel)

import User.Model exposing (..)
import Json.Encode as Encode exposing (..)
import Json.Decode as Decode exposing (..)

-- MODEL

type alias AppModel =
    { userModel : User.Model
    }


initialModel : AppModel
initialModel =
    { userModel = User.initialUser
    }



-- DECODER

-- Decode the saved model from localstorage
modelDecoder : Decode.Decoder AppModel
modelDecoder =
  Decode.map5 modelConstructor
    (field "uid" Decode.string) 
    (field "name" Decode.string) 
    (field "url" Decode.string)
    (field "loginStatus" Decode.string |> andThen User.loginStatusDecoder )
    (field "userType" Decode.string |> andThen User.userTypeDecoder )




-- HELPERS

-- helper to construct model from the decoded object
modelConstructor : String -> String -> String -> User.LoginStatus -> User.UserType -> AppModel
modelConstructor uid name picture status userType =
    AppModel { uid = uid
    , name = name
    , url = picture
    , loginStatus = status
    , userType = userType
    }



-- Maybe object helper 
resultToMaybe : Result String AppModel -> Maybe AppModel
resultToMaybe result =
  case result of
    Result.Ok model -> Just model
    Result.Err error -> Debug.log error Nothing    