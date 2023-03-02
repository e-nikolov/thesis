.PHONY: notion pandoc

notion:
	rm -rf notion/*
	notion-exporter https://www.notion.so/e-nikolov/Abstract-b929d53335044965ae8cd441f1f13e4e | tail -n +2 > notion/00-abstract.md
	notion-exporter https://www.notion.so/e-nikolov/Introduction-0b4232f7ee5143748f6fa54c5cf94daa > notion/01-introduction.md
	notion-exporter https://www.notion.so/e-nikolov/Goals-c4dcba251ecc47069a9d56e7d08ecaa1 > notion/02-goals.md
	notion-exporter https://www.notion.so/e-nikolov/Technical-Survey-1318176db63c4079a136dd9ff89b5ed9 | sed s@ocaml@terraform@g > notion/03-technical-survey.md
	notion-exporter https://www.notion.so/e-nikolov/Design-d2e115f74a5a49f186d498ff69b1e912 | sed s@ocaml@terraform@g > notion/04-design.md
	notion-exporter https://www.notion.so/e-nikolov/Implementation-7143d3fa0d5e42578b28ffe362149d59 | sed s@ocaml@terraform@g > notion/05-implementation.md
	notion-exporter https://www.notion.so/e-nikolov/Conclusions-cafd82912c3642e0a3642e4927cd1175 > notion/06-conclusions.md

pandoc:
	pandoc notion/*.md \
		-f markdown+citations+raw_tex+implicit_figures+rebase_relative_paths+link_attributes+fenced_code_blocks+fancy_lists+fenced_code_attributes+backtick_code_blocks \
		-o output.tex \
		--biblatex \
		--highlight-style pygments \
		--top-level-division chapter \
		--number-sections
	
	# latexmk -synctex=1 -interaction=nonstopmode -file-line-error -pdf -outdir=./build -g -quiet output.tex
	latexmk -synctex=1 -interaction=nonstopmode -file-line-error -pdf -outdir=./build -g -quiet report2.tex
