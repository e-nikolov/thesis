
.PRECIOUS: prep/latex/%.tex
.PRECIOUS: %.tex %/latex
MAKEFLAGS += --no-print-directory

format=markdown+fenced_divs+inline_code_attributes+header_attributes+smart+strikeout+superscript+subscript+task_lists+definition_lists+pipe_tables+yaml_metadata_block+inline_notes+table_captions+citations+raw_tex+implicit_figures+rebase_relative_paths+link_attributes+fenced_code_blocks+fancy_lists+fenced_code_attributes+backtick_code_blocks
PANDOC=pandoc \
		-f $(format) \
		--biblatex \
		--highlight-style my.theme \
		--top-level-division chapter \
		--number-sections

%.pdf!: %.pdf-
	$(MAKE) $*.pdf

%.pdf-:
	rm -rf $*.pdf build/ $*/latex

%.pdf: %/latex
	$(MAKE) $@~

%.pdf~:
	mkdir -p build/$*/latex

	latexmk \
		-outdir=build \
		-synctex=1 \
		-interaction=nonstopmode \
		-file-line-error \
		-pdf \
		--output-directory="build" \
		-shell-escape \
		-f \
		-recorder \
		-gg \
		-silent \
		$*.tex
	
	rsync ./build/$*.pdf ./$*.pdf
 
	@echo ----------------------
	@echo Done creating $*.pdf
	@echo ----------------------

presentation.html: presentation/*.md FORCE
	$(PANDOC) \
		--citeproc \
		-t dzslides \
		--embed-resources --standalone \
		--bibliography references.bib \
		-o $@ \
		presentation/*.md

%.html: %/*.md
	$(PANDOC) \
		--citeproc \
		--bibliography references.bib \
		-o $@ \
		$*/*.md


%/latex: %/*.md
# 	map all .md files from the parent directory to .tex files in the latex directory
	$(MAKE) $(?:$*/%.md=$@/%.tex) $@/full.tex $@/beamer.tex
	touch $@

%/latex/full.tex: %/*.md
	$(PANDOC) \
		-o $@ \
		$*/*.md

%/latex/beamer.tex: %/*.md
	$(PANDOC) \
		-w beamer \
		-o $@ \
		$*/*.md

.SECONDEXPANSION:
# thesis/latex/chapter.tex -> thesis/chapter.md 
%.tex: $$(shell dirname $$(*D))/$$(*F).md
	mkdir -p $(*D)
	$(PANDOC) \
		-o $@ \
		$<

clean:
	rm -rf ./build

FORCE:
	@echo
