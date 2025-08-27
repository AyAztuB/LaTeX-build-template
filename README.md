# LaTeX Builder using Makefiles

This is a demo of a Makefile created to build latex to pdf using only a
small number of variables. Those variables are used to describe each paper
to compile.

## Dependencies

The Makefile needs:
- GNU/Make (Obviously)
- texlive-full (or at least the needed packages and the following commands: `pdflatex`, `bibtex`, `makeglossaries`)

## Usage

The compilation is described in `latex.mak`.
To show how the builder can be used, a `Makefile` is provided.
As explained in the Makefile, some variables need to be set to describe the
file-tree, the dependencies, the papers to build, ...
At the end of the Makefile, once all variables have been set, the `latex.mak`
file has to be included.
It will automatically build the rules and dependencies.

Finally, the builder is only made for linux.
You can still use it in Docker:
```sh
docker run --rm \
            -v $PWD:/workdir \
            -w /workdir \
            texlive/texlive:latest \
            make
```

Also, a Github pipeline is given as an example to build pdfs, upload them as
artifacts, and deploy them on the Github pages.

If you want to build your own minimalist docker image for the github workflow,
you need to create a Dockerfile and follow the following instructions:
```sh
# Authenticate with GitHub Container Registry
echo $GITHUB_TOKEN | docker login ghcr.io -u <your-username> --password-stdin

# Build your image
docker build -t ghcr.io/<your-username>/<your-repo>:latex .

# Push it
docker push ghcr.io/<your-username>/<your-repo>:latex
```
Then, you have to replace the `jobs/build/steps/[1]:"Build PDFs with texlive/texlive"`
with the following step:
```yml
- name: Run Make inside prebuilt LaTeX container
  run: |
    docker run --rm -v ${{ github.workspace }}:/workdir \
    ghcr.io/<your-username>/<your-repo>:latex \
    make
```
