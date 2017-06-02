import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode exposing (..)
import Json.Encode
import Http
import Dom

type Msg
    = Nothing


-- Model

type alias Model =
    {}

init : (Model, Cmd Msg)
init =
    ({}, Cmd.none)



-- Update

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Nothing ->
            (model, Cmd.none)




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
