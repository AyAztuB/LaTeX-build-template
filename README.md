# LaTeX Makefile Builder

This project provides a **reusable GNU Makefile fragment (`latex.mak`)** for building LaTeX projects into PDF files.
It supports:

* Multiple LaTeX project targets
* `bibtex` integration
* `makeglossaries` integration
* Configurable build and source directories
* Optional per-target flags and dependencies
* A Docker-based build workflow
* A GitHub Actions workflow for automated builds, artifact uploads, and publishing to GitHub Pages

This allows you to easily manage LaTeX projects with consistent, reproducible builds across local and CI environments.

---

## Features

* **Automatic Dependency Management**
  Rebuilds when source files change.
  *(See [Limitations](#limitations) for details about `.aux` files.)*
* **Per-Target Customization**
  Define flags, dependencies, custom main `.tex` file names, and per-paper directories.
* **BibTeX and Glossaries Support**
  Automatically runs `bibtex` or `makeglossaries` when enabled for a target.
* **Docker Support**
  Build without installing TeX Live locally.
* **GitHub Actions Integration**
  Build PDFs, upload artifacts, and publish to GitHub Pages with a ready-to-use workflow.

---

## Getting Started

### 1. Project Setup

Add `latex.mak` to your repository. Then create a `Makefile` that defines your papers and includes `latex.mak`.

#### Minimal Example

```makefile
# Define your papers (list of targets, without extension)
PAPERS = example1

# Strongly recommended: use a build directory for intermediate files
BUILD_DIR = build/

# Optionally specify global source directory
# SRC_DIR = papers/

# Optionally configure per-paper variables
# example1_SRC_DIR = papers/example1/
# example1_FLAGS = --shell-escape
# example1_DEPS = macros.tex
# example1_TEX  = main.tex
# example1_BIB  = references.bib
# example1_GLOSSARY = glossary

# Include the builder
include latex.mak
```

Then build with:

```sh
make
```

This will produce `example1.pdf`.

---

### 2. Available Variables

| Variable      | Required                 | Description                                                                                                                          |
| ------------- | --------------------     | ------------------------------------------------------------------------------------------------------------------------------------ |
| `PAPERS`      | **Yes**                  | List of target names (without `.tex`). Example: `PAPERS = report thesis`                                                             |
| `BUILD_DIR`   | No **(but recommended)** | Directory for intermediate LaTeX build files. Must end with `/` if used. Strongly encouraged to ensure `make clean` works correctly. |
| `SRC_DIR`     | No                       | Global source directory for all papers. Must end with `/` if used.                                                                   |
| `$1_SRC_DIR`  | No                       | Source directory for a specific paper (`$1` = paper name).                                                                           |
| `$1_FLAGS`    | No                       | Extra flags passed to `pdflatex` for this paper.                                                                                     |
| `$1_DEPS`     | No                       | Extra dependencies besides the main `.tex` file.                                                                                     |
| `$1_TEX`      | No                       | Main `.tex` filename (default: `$1.tex`).                                                                                            |
| `$1_BIB`      | No                       | Enables `bibtex` and specifies the `.bib` file path.                                                                                 |
| `$1_GLOSSARY` | No                       | Enables `makeglossaries` and specifies glossary source.                                                                              |

---

### 3. Provided Targets

The `latex.mak` file defines the following **PHONY** targets:

| Target      | Description                                                    |
| ----------- | -------------------------------------------------------------- |
| `all`       | Default target - builds all `PAPERS` into PDFs.                |
| `clean`     | Removes all intermediate/temporary files (but **keeps PDFs**). |
| `veryclean` | Performs `clean` and also removes the generated PDFs.          |

Intermediate build rules are also defined internally to handle `pdflatex`, `bibtex`, and `makeglossaries` in the correct order.

---

### 4. Examples

See [`examples/builder/`](examples/builder/) for sample projects using `latex.mak`.

---

## Building with Docker

You can build without installing TeX Live locally by using the official TeX Live container:

```sh
docker run --rm \
            -v $PWD:/workdir \
            -w /workdir \
            --user $(id -u):$(id -g) \
            texlive/texlive:latest \
            make
```

This ensures consistent builds across environments.

---

## GitHub Actions Workflow

A sample GitHub Actions workflow is included in `.github/workflows/`.
It:

* Builds all PDFs defined in `PAPERS`
* Uploads them as build artifacts
* Generates an `index.html` listing available PDFs
* Publishes the results to GitHub Pages

To enable it:

1. Copy the provided workflow into `.github/workflows/latex.yml`.
2. Push to your repository.
3. Enable GitHub Pages in your repository settings (e.g., from the `gh-pages` branch).

---

## Limitations

* **Dependency Tracking Is Not Perfect**
  The `.aux` files generated by LaTeX change on every run, which can cause Make to rebuild PDFs even when nothing significant has changed.
* **Using `BUILD_DIR` Is Highly Recommended**
  This isolates intermediate files and allows `make clean` to work reliably.
  Without `BUILD_DIR`, `clean` may leave stray files in your source directories.

---

## Requirements

* GNU Make
* TeX Live (or Docker with `texlive/texlive:latest`)

Optional:

* `bibtex` (if using `$1_BIB`)
* `makeglossaries` (if using `$1_GLOSSARY`)

---

## License

This project is released under the MIT License.
You are free to use, modify, and distribute it under the terms of that license.

---
