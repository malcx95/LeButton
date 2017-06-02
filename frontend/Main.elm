module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Json.Encode
import Time exposing (..)
import Http

type Msg
    = ButtonPressed
    | UpdateReceived Bool
    | ScoreReceived Int
    | IdReceived String
    | ButtonPressResultReceived Bool
    | NetworkError Http.Error
    | Tick Time


-- Model

type alias Model =
    { buttonState: Maybe Bool
    , score: Maybe Int
    , id: Maybe String
    }

init : (Model, Cmd Msg)
init =
    (Model Nothing Nothing Nothing, getId)



-- Update

requestWithId : Maybe String -> (String -> Cmd Msg) -> Cmd Msg
requestWithId maybeId requestFun =
    case maybeId of
        Nothing ->
            Cmd.none
        Just id ->
            requestFun id


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ButtonPressed ->
            (model, requestWithId model.id pressButton)
        UpdateReceived buttonState ->
            ({model | buttonState = Just buttonState}, Cmd.none)
        ScoreReceived value ->
            ({model | score = Just value}, Cmd.none)
        IdReceived id ->
            ({model | id = Just id}, Cmd.none)
        ButtonPressResultReceived sucess ->
            (model, Cmd.none)
        Tick time ->
            (model, requestWithId model.id getState)
        NetworkError e ->
            let
                _ = Debug.log "Network error:" e
            in
                (model, Cmd.none)


makeJson : List (String, String) -> String
makeJson vars =
    let
        varStrings = List.map
                (\(name, value) -> "'" ++ name ++ "':'" ++ value ++ "'" )
                vars

        allStrings =
            List.intersperse "," varStrings
    in
        "{" ++ (String.concat allStrings) ++ "}"


checkHttpAttempt : (a -> Msg) -> Result Http.Error a -> Msg
checkHttpAttempt func res =
    case res of
        Ok val ->
            func val
        Err e ->
            NetworkError e


pressButton : String -> Cmd Msg
pressButton id =
    let
        url =
            makeJson [("action", "push"), ("id", id)]
    in
        Http.send
            (checkHttpAttempt ButtonPressResultReceived)
            (Http.get url Json.Decode.bool)


getId : Cmd Msg
getId =
    Http.send
    (checkHttpAttempt IdReceived)
    (Http.post "" (Http.stringBody "text/json" (makeJson [("action","new")])) Json.Decode.string)


getState : String -> Cmd Msg
getState id =
    Http.send
    (checkHttpAttempt UpdateReceived)
    (Http.get (makeJson [("action", "get"), ("id", id)]) Json.Decode.bool)


-- View

view : Model -> Html Msg
view model =
    let
        scoreText = case model.score of
            Just score -> "Score: " ++ toString score
            Nothing -> "Score not fetched"
    in
        div []
            [ button [onClick ButtonPressed] [text "Press"]
            , p [] [text <| "Score: " ++ scoreText]
            ]



-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
    every (100 * millisecond) Tick




-- Main

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
