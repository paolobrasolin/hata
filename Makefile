_flags/%/banner.dvi: _flags/*/banner.tex
	latexmk -dvi -output-directory=$(@D) $<

_flags/%/banner.svg: _flags/*/banner.dvi
	dvisvgm $< --output=$@
