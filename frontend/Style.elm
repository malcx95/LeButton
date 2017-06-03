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
    | ButtonOuter
    | BorderDown
    | BorderUp


buttonSize = 150
borderWidth = 5
outerBorderWidth = 3
outerSize = buttonSize + borderWidth * 2

containerSize = 400

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
            , border3 (Css.px borderWidth) solid buttonBorderColor
            ]
        , Css.class ButtonOuter
            [ height <| Css.px outerSize
            , width <| Css.px outerSize
            , borderRadius <| Css.px <| (outerSize / 2)
            , margin2 (Css.px 0) auto
            ]
        , Css.class BorderUp
            [ border3 (Css.px outerBorderWidth) solid (hex "ff0000")
            ]
        , Css.class BorderDown
            [ border3 (Css.px outerBorderWidth) solid (hex "00FF00")
            ]
        ]
    ]




cssFiles : CssFileStructure
cssFiles =
    toFileStructure [ ( "output/css/GlobalStyle.css", Css.File.compile globalStyle ) ]



main : CssCompilerProgram
main =
    Css.File.compiler files cssFiles
