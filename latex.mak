## TODO: test glossary and recompilation

.PHONY: all clean veryclean

.SECONDEXPANSION:

all: $(BUILD_DIR) $(PAPERS:%=%.pdf)

$(BUILD_DIR):
	@mkdir -p $@

PDF_FLAGS=
GLO_FLAGS=
ifdef BUILD_DIR
PDF_FLAGS=--output-directory=$(BUILD_DIR)
GLO_FLAGS=-d $(BUILD_DIR)
# TEXMFOUTPUT="${BUILD_DIR}:"
# BSTINPUTS="${BUILD_DIR}:"
endif

ifdef SRC_DIR
# TEXINPUTS="${SRC_DIR}:"
# BIBINPUTS="${SRC_DIR}:"
endif

# Generic template for building PDFs
define PDF_template =
ifndef $1_SRC_DIR
ifdef SRC_DIR
$1_SRC_DIR=$(SRC_DIR)
endif
endif

ifndef $1_TEX
$1_TEX=$1.tex
endif

$1_BUILD_CMD=$$($1_TEX:%.tex=%)

$(BUILD_DIR)$$($1_BUILD_CMD).aux: $$($1_SRC_DIR)$$($1_TEX) $$(patsubst %, $$($1_SRC_DIR)%, $$($1_DEPS))
	TEXINPUTS=$$($1_SRC_DIR): pdflatex --draftmode $(PDF_FLAGS) $$($1_FLAGS) $$($1_BUILD_CMD)

$(BUILD_DIR)$$($1_BUILD_CMD).bbl: $(BUILD_DIR)$$($1_BUILD_CMD).aux $$($1_SRC_DIR)$$($1_BIB)
	BIBINPUTS=$$($1_SRC_DIR): bibtex $(BUILD_DIR)$$($1_BUILD_CMD)

$(BUILD_DIR)$$($1_BUILD_CMD).gls: $(BUILD_DIR)$$($1_BUILD_CMD).aux $$($1_SRC_DIR)$$($1_GLOSSARY)
	makeglossaries $(GLO_FLAGS) $$($1_BUILD_CMD)

$1_BUILD_DEPS=$(BUILD_DIR)$$($1_BUILD_CMD).aux
ifdef $1_BIB
$1_BUILD_DEPS+=$(BUILD_DIR)$$($1_BUILD_CMD).bbl
endif
ifdef $1_GLOSSARY
$1_BUILD_DEPS+=$(BUILD_DIR)$$($1_BUILD_CMD).gls
endif

$(BUILD_DIR)$$($1_BUILD_CMD).pdf: $$($1_BUILD_DEPS) $$($1_SRC_DIR)$$($1_BUILD_CMD).tex
	TEXINPUTS=$$($1_SRC_DIR): pdflatex $(PDF_FLAGS) $$($1_FLAGS) $$($1_BUILD_CMD)
	TEXINPUTS=$$($1_SRC_DIR): pdflatex $(PDF_FLAGS) $$($1_FLAGS) $$($1_BUILD_CMD)

ifneq ($$($1_BUILD_CMD), $1)
$(BUILD_DIR)$1.pdf: $(BUILD_DIR)$$($1_BUILD_CMD).pdf
	@mv $(BUILD_DIR)$$($1_BUILD_CMD).pdf $(BUILD_DIR)$1.pdf
endif
endef

$(foreach p,$(PAPERS),$(eval $(call PDF_template,$(p))))

ifdef BUILD_DIR
%.pdf: $(BUILD_DIR) $(BUILD_DIR)%.pdf
	@mv $(BUILD_DIR)$@ $@
endif

ifdef BUILD_DIR
clean:
	${RM} -rf ${BUILD_DIR}
else
clean:
	${RM} *.aux *.log *.out *.bbl *.blg *.toc *.gl* *.ist *.acn *.acr *.alg *.lof *.lot *.lol *.run.xml *.bcf *.fdb_latexmk *.fls
endif

veryclean: clean
	${RM} $(PAPERS:%=%.pdf)

