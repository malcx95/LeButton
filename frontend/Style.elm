port module Style exposing (..)

import Css exposing (..)
import Css.File exposing (..)
import Css.Elements exposing (..)
import Css.Namespace exposing (namespace)
import Html.Attributes exposing (style)
import Html
import Html.CssHelpers


-- Boilerplate
port files : CssFileStructure -> Cmd msg


toStyle =
    Css.asPairs >> Html.Attributes.style

{id, class, classList} =
    Html.CssHelpers.withNamespace ""



type CssClasses
    = Button
    | ButtonDown
    | ButtonUp


buttonSize = 150


buttonBorderColor =
    hex "000000"

globalStyle =
    [(stylesheet)
        [ Css.class Button
            [ width <| Css.px buttonSize
            , height <| Css.px buttonSize
            , borderRadius <| Css.px <| buttonSize / 2
            , textAlign center
            , verticalAlign center
            , lineHeight <| Css.px buttonSize
            , border3 (Css.px 5) solid buttonBorderColor
            ]
        ]
    ]




cssFiles : CssFileStructure
cssFiles =
    toFileStructure [ ( "output/css/GlobalStyle.css", Css.File.compile globalStyle ) ]



main : CssCompilerProgram
main =
    Css.File.compiler files cssFiles
