all:
	make build
	make css


build:
	elm-make Main.elm --output=output/compiled.js

css:
	elm-css Style.elm --module Style
