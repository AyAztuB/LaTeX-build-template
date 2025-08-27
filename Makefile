# This Makefile is a demo on how to use the latex builder.
# The build process is implemented in "latex.mak" (included at the end of this file)
# The build process needs some variables (use to describe the targets)

PAPERS=test1 main

BUILD_DIR=build/
# SRC_DIR=src/

test1_DEPS=main.c
test1_FLAGS=--shell-escape "\PassOptionsToPackage{outputdir=build}{minted}\input"
test1_SRC_DIR=example_1/

main_SRC_DIR=example_2/
main_DEPS=img.png
main_FLAGS=--shell-escape
main_BIB=refs.bib
main_GLOSSARY=glossary.tex

include latex.mak
