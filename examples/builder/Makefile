# This Makefile is a demo on how to use the latex builder.
# The build process is implemented in "latex.mak" (included at the end of this file)
# The build process needs some variables (use to describe the targets)

PAPERS=test1 example2

BUILD_DIR=build/
# SRC_DIR=src/

MINTED_VERSION := $(shell mkdir -p build; cd build/ && latex -halt-on-error -interaction=nonstopmode -shell-escape '\RequirePackage{minted}\makeatletter\typeout{MINTEDVERSION:\csname ver@minted.sty\endcsname}\stop' | grep '^MINTEDVERSION:' | sed -E 's/.*v([0-9]+\.[0-9]+).*/\1/')

test1_DEPS=main.c
test1_SRC_DIR=example_1/
test1_FLAGS=--shell-escape
ifeq ($(shell echo $(MINTED_VERSION) \< 3.0 | bc), 1)
	test1_FLAGS+="\PassOptionsToPackage{outputdir=build}{minted}"
endif
test1_FLAGS+="\def\TEXSRC{${test1_SRC_DIR}}\input"

example2_SRC_DIR=example_2/
example2_DEPS=img.png
example2_FLAGS=--shell-escape
example2_BIB=refs.bib
example2_GLOSSARY=glossary.tex
example2_TEX=main.tex

latex.mak:
	wget https://raw.githubusercontent.com/AyAztuB/LaTeX-build-template/refs/heads/main/latex.mak

include latex.mak
