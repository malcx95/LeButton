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


globalStyle =
    [(stylesheet)
        [ Css.class Button
            [backgroundColor <| hex "ff6666"]
        ]
    ]




cssFiles : CssFileStructure
cssFiles =
    toFileStructure [ ( "output/css/GlobalStyle.css", Css.File.compile globalStyle ) ]



main : CssCompilerProgram
main =
    Css.File.compiler files cssFiles
