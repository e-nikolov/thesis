

MAKEFLAGS += --no-print-directory
# pandock=docker run --rm -v "$(shell pwd):/data" -u $(shell id -u):$(shell id -g) pandoc/latex:3.1
pandock=pandoc
format=markdown+fenced_divs+inline_code_attributes+header_attributes+smart+strikeout+superscript+subscript+task_lists+definition_lists+pipe_tables+yaml_metadata_block+inline_notes+table_captions+citations+raw_tex+implicit_figures+rebase_relative_paths+link_attributes+fenced_code_blocks+fancy_lists+fenced_code_attributes+backtick_code_blocks
PANDOC=$(pandock) \
		-f $(format) \
		--biblatex \
		--highlight-style shared/my.theme \
		--top-level-division chapter \
		--number-sections \
		--file-scope
		
#		\
# .PRECIOUS: prep/latex/%.tex %.tex %/latex %/latex/

all: thesis.pdf notes.pdf prep.pdf presentation.pdf


test:
	@echo test

%.pdf!:
	rm -rf $*.pdf
	$(MAKE) $*.pdf

%.pdf-!: %.pdf-
	$(MAKE) $*.pdf

%.pdf-~: %.pdf-
	$(MAKE) $*.pdf~

%.pdf-:
	rm -rf $*.pdf build/ $*/latex/

%.pdf: %.tex
	$(MAKE) $@~

$(wildcard *.tex): %.tex: %/latex/full.tex
	@echo root tex file: $@
	touch $@

%.pdf~:
	latexmk \
		-synctex=1 \
		-interaction=nonstopmode \
		-file-line-error \
		--emulate-aux-dir \
		-pdf \
		-time \
		--output-directory="build" \
		-quiet \
		$*.tex

# \
		-use-make \
		-use-make \
		-shell-escape \
		--aux-directory="build/aux" \
		-f \

	rsync ./build/$*.pdf ./$*.pdf
 
	@echo ----------------------
	@echo Done creating $*.pdf
	@echo ----------------------

presentation.html: presentation/*.md FORCE
	$(PANDOC) \
		--citeproc \
		-t dzslides \
		--embed-resources --standalone \
		--bibliography shared/references.bib \
		-o $@ \
		presentation/*.md

%.html: %/*.md
	$(PANDOC) \
		--citeproc \
		--bibliography shared/references.bib \
		-o $@ \
		$*/*.md

%/latex:
	mkdir -p $@

%/latex/full.tex: %/**.md
# 	map all .md files from the parent directory to .tex files in the latex directory
	$(MAKE) $(?:"$*/%.md"="$*/latex/%.tex") $*/latex/beamer.tex

	$(PANDOC) \
		-o $@ \
		$*/*.md

%/latex/beamer.tex: %/*.md | %/latex 
	$(PANDOC) \
		-w beamer \
		-o $@ \
		$*/*.md

.SECONDEXPANSION:
# thesis/latex/chapter.tex -> thesis/chapter.md 
%.tex: $$(shell dirname $$(*D))/$$(*F).md | $$(*D)
	$(PANDOC) \
		-o $@ \
		$<

clean:
	rm -rf ./build

FORCE:
	@echo
