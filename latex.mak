## Author: AyAztuB
## License: MIT
## Copyright (c) 2025 AyAztuB

.PHONY: all clean veryclean help $(PAPERS)

BUILD_DIR ?= build/

.SECONDEXPANSION:

.DEFAULT_GOAL :=

all: $(PAPERS:%=%.pdf)

$(PAPERS): %: %.pdf

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

$1_ALL_DIRS=$$(addprefix $(BUILD_DIR), $$(dir $$($1_DEPS)))

$(BUILD_DIR)$1.aux: $$($1_SRC_DIR)$$($1_TEX) $$(patsubst %, $$($1_SRC_DIR)%, $$($1_DEPS))
	@mkdir -p $$(@D) $$($1_ALL_DIRS)
	BIBINPUTS=$$($1_SRC_DIR): TEXINPUTS=$$($1_SRC_DIR): pdflatex --draftmode $(PDF_FLAGS) -jobname=$1 $$($1_FLAGS) $$($1_SRC_DIR)$$($1_TEX)

ifeq ($$($1_BIB_TYPE),biber)
$1_BIB_DEP = $(BUILD_DIR)$1.bcf
else
$1_BIB_DEP = $(BUILD_DIR)$1.aux
endif

$(BUILD_DIR)$1.bbl: $$($1_BIB_DEP) $$($1_SRC_DIR)$$($1_BIB)
ifeq ($$($1_BIB_TYPE),biber)
	biber --input-directory $(BUILD_DIR) --output-directory $(BUILD_DIR) $1
else
	BIBINPUTS=$$($1_SRC_DIR): bibtex $(BUILD_DIR)$1
endif

$(BUILD_DIR)$1.gls: $(BUILD_DIR)$1.aux $$($1_SRC_DIR)$$($1_GLOSSARY)
	makeglossaries $(GLO_FLAGS) $1

$1_BUILD_DEPS=$(BUILD_DIR)$1.aux
ifdef $1_BIB
$1_BUILD_DEPS+=$(BUILD_DIR)$1.bbl
endif
ifdef $1_GLOSSARY
$1_BUILD_DEPS+=$(BUILD_DIR)$1.gls
endif

$(BUILD_DIR)$1.pdf: $$($1_BUILD_DEPS) $$($1_SRC_DIR)$$($1_TEX)
	TEXINPUTS=$$($1_SRC_DIR): pdflatex $(PDF_FLAGS) -jobname=$1 $$($1_FLAGS) $$($1_SRC_DIR)$$($1_TEX)
	TEXINPUTS=$$($1_SRC_DIR): pdflatex $(PDF_FLAGS) -jobname=$1 $$($1_FLAGS) $$($1_SRC_DIR)$$($1_TEX)
endef

$(foreach p,$(PAPERS),$(eval $(call PDF_template,$(p))))

%.pdf: $(BUILD_DIR)%.pdf
	@mv -f $^ $@

clean:
	${RM} -rf ${BUILD_DIR}

veryclean: clean
	${RM} $(PAPERS:%=%.pdf)

help:
	@echo "LaTeX Build Template"
	@echo "--------------------"
	@echo "Build Directory: $(BUILD_DIR)"
	@echo ""
	@echo "Available Papers:"
	@$(foreach p,$(PAPERS), \
		echo "  * $(p)"; \
		echo "      Source: $($(p)_SRC_DIR)"; \
		echo "      Main:   $($(p)_TEX)"; \
		echo "      Output: $(p).pdf"; \
		echo ""; \
	)

