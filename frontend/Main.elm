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




-- View

view : Model -> Html Msg
view model =
    div [] []



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
