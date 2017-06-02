import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Json.Encode
import Http
import Dom

type Msg
    = ButtonPressed
    | UpdateReceived Bool
    | ScoreReceived Int
    | IdReceived String
    | ButtonPressResultReceived Bool
    | NetworkError Http.Error


-- Model

type alias Model =
    { buttonState: Maybe Bool
    , score: Maybe Int
    , id: Maybe String
    }

init : (Model, Cmd Msg)
init =
    (Model Nothing Nothing Nothing, Cmd.none)



-- Update

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ButtonPressed ->
            (model, Cmd.none)
        UpdateReceived buttonState ->
            ({model | buttonState = Just buttonState}, Cmd.none)
        ScoreReceived value ->
            ({model | score = Just value}, Cmd.none)
        IdReceived id ->
            ({model | id = Just id}, Cmd.none)
        ButtonPressResultReceived sucess ->
            (model, Cmd.none)
        NetworkError e ->
            let
                _ = Debug.log "Network error:" e
            in
                (model, Cmd.none)



checkHttpAttempt : (a -> Msg) -> Result Http.Error a -> Msg
checkHttpAttempt func res =
    case res of
        Ok val ->
            func val
        Err e ->
            NetworkError e


pressButton : Cmd Msg
pressButton =
    let
        url =
            "{\"action\":\"push\"}"
    in
        Http.send
            (checkHttpAttempt ButtonPressResultReceived)
            (Http.get url Json.Decode.bool)



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
    Sub.none




-- Main

main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
