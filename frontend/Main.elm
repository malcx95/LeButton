module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Json.Encode
import Time exposing (..)
import Http
import Style

type Msg
    = ButtonPressed
    | UpdateReceived Bool
    | ScoreReceived Int
    | IdReceived String
    | ButtonPressResultReceived Bool
    | NetworkError Http.Error
    | Tick Time
    | SlowTick Time


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
        SlowTick time ->
            (model, requestWithId model.id getScore)
        NetworkError e ->
            let
                _ = Debug.log "Network error:" e
            in
                (model, Cmd.none)


makeJson : List (String, String) -> String
makeJson vars =
    let
        varStrings = List.map
                (\(name, value) -> "\"" ++ name ++ "\":\"" ++ value ++ "\"" )
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
    Http.send
    (checkHttpAttempt ButtonPressResultReceived)
    <| Http.post ""
           (Http.stringBody "text/json" (makeJson [("action", "push"), ("id", id)]))
           (Json.Decode.field "success" Json.Decode.bool)


getId : Cmd Msg
getId =
    Http.send
    (checkHttpAttempt IdReceived)
    <| Http.post ""
               (Http.stringBody "text/json" (makeJson [("action","new")]))
               (Json.Decode.field "id" Json.Decode.string)


getState : String -> Cmd Msg
getState id =
    Http.send
    (checkHttpAttempt UpdateReceived)
    <| Http.post ""
               (Http.stringBody "text/json" (makeJson [("action","get"), ("id", id)]))
               (Json.Decode.field "state" Json.Decode.bool)


getScore : String -> Cmd Msg
getScore id =
    Http.send
    (checkHttpAttempt ScoreReceived)
    <| Http.post ""
               (Http.stringBody "text/json" (makeJson [("action","score"), ("id", id)]))
               (Json.Decode.field "score" Json.Decode.int)


-- View

view : Model -> Html Msg
view model =
    let
        buttonStyle =
            [ Style.Button
            , case Maybe.withDefault False model.buttonState of
                True ->
                    Style.ButtonUp
                False ->
                    Style.ButtonDown
            ]
    in
        div []
            [ div [onClick ButtonPressed, Style.class buttonStyle] [text "Press"]
            , p [] [text <| "Button state: " ++ (toString <| Maybe.withDefault False model.buttonState)]
            , p [] [text <| "Score: " ++ (toString <| Maybe.withDefault 0 model.score)]
            , p [] [text <| "Your id: " ++ (Maybe.withDefault "-" model.id)]
            ]



-- Subscriptions

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ every (100 * millisecond) Tick
        , every (1000 * millisecond) SlowTick
        ]




-- Main

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
