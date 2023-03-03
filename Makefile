
SHELL := /home/enikolov/.nix-profile/bin/zsh
.PHONY: notion pandoc *.tex
.PRECIOUS: prep/latex/%.tex
.PRECIOUS: %.tex
MAKEFLAGS += --no-print-directory

format=markdown+fenced_divs+inline_code_attributes+header_attributes+smart+strikeout+superscript+subscript+task_lists+definition_lists+pipe_tables+yaml_metadata_block+inline_notes+table_captions+citations+raw_tex+implicit_figures+rebase_relative_paths+link_attributes+fenced_code_blocks+fancy_lists+fenced_code_attributes+backtick_code_blocks

%.pdf: %.tex
	mkdir -p build/presentation/latex

	latexmk \
		-outdir=build \
		-synctex=1 \
		-interaction=nonstopmode \
		-file-line-error \
		-pdf \
		--output-directory="build" \
		$< \
		-shell-escape \
		-f \
		-recorder \
		-gg \
		-verbose


	rsync ./build/$*.pdf ./$*.pdf

%.html: %/*.md
	pandoc $*/*.md \
		-f $(format) \
		--biblatex \
		--highlight-style my.theme \
		--top-level-division chapter \
		--number-sections \
		--citeproc \
		--bibliography references.bib \
		-o $@

.SECONDEXPANSION:

# root <filename>.tex files depend on <filename>/latex/*.tex files
# which will be generated from <filename>/*.md files
*.tex: $$(patsubst $$*/%.md, $$*/latex/%.tex, $$(wildcard $$*/*.md))
#	pandoc $*/<011-060>*.md \

	pandoc $*/*.md \
		-f $(format) \
		--biblatex \
		--highlight-style my.theme \
		--top-level-division chapter \
		--number-sections \
		-w beamer \
		-o $*/latex/full.tex
	
# the tex files are generated by pandoc from the md files
%.tex: $$(shell dirname $$(shell dirname $$*))/$$(notdir $$*).md
	@mkdir -p $(dir $@)
	pandoc $< \
		-f $(format) \
		--biblatex \
		--highlight-style my.theme \
		--top-level-division chapter \
		--number-sections \
		-o $@

%/latex-clean:
	rm -rf $*/latex ./build


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
	pandoc prep/*.md \
		-f $(format) \
		-o output.tex \
		--biblatex \
		--highlight-style my.theme \
		--top-level-division chapter \
		--number-sections
	
	# latexmk -synctex=1 -interaction=nonstopmode -file-line-error -pdf -outdir=./build -g -quiet output.tex
	latexmk -synctex=1 -interaction=nonstopmode -file-line-error -pdf -outdir=./build -g -quiet report2.tex

lualatex:
	lualatex \
		-shell-escape \
		--output-directory=build \
		-synctex=1 \
		-interaction=nonstopmode \
		-file-line-error \
		-recorder \
		-output-directory="build" \
		"report.tex"
