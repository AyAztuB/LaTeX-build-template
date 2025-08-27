# This Makefile is a demo on how to use the latex builder.
# The build process is implemented in "latex.mak" (included at the end of this file)
# The build process needs some variables (use to describe the targets)

PAPERS=test1 main

BUILD_DIR=build/
# SRC_DIR=src/

MINTED_VERSION := $(shell [ -d build/ ] || mkdir -p build; cd build/ && latex -halt-on-error -interaction=nonstopmode -shell-escape '\RequirePackage{minted}\makeatletter\typeout{MINTEDVERSION:\csname ver@minted.sty\endcsname}\stop' | grep '^MINTEDVERSION:' | sed -E 's/.*v([0-9]+\.[0-9]+).*/\1/')

test1_FLAGS=--shell-escape
ifeq ($(shell echo $(MINTED_VERSION) \< 3.0 | bc), 1)
	test1_FLAGS+="\PassOptionsToPackage{outputdir=build}{minted}\input"
endif
test1_DEPS=main.c
test1_SRC_DIR=example_1/

main_SRC_DIR=example_2/
main_DEPS=img.png
main_FLAGS=--shell-escape
main_BIB=refs.bib
main_GLOSSARY=glossary.tex

include latex.mak
