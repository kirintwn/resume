VERSION 0.6
all:
  BUILD +test
  BUILD +build

test:
  BUILD +test-prettier
  BUILD +test-super-linter

test-prettier:
  FROM node:16.15.1-alpine3.15
  RUN npm install --global prettier@2.7.1
  WORKDIR /opt/resume
  COPY --dir . ./
  RUN prettier --check .

test-super-linter:
  FROM github/super-linter:slim-v4.9.4
  ENV RUN_LOCAL="true"
  ENV MULTI_STATUS="false"
  ENV VALIDATE_ALL_CODEBASE="true"
  ENV VALIDATE_EDITORCONFIG="true"
  ENV VALIDATE_MD="true"
  ENV VALIDATE_YAML="true"
  ENV FILTER_REGEX_EXCLUDE=".*/(CHANGELOG\.md)"
  ENV DEFAULT_WORKSPACE="/opt/resume"
  WORKDIR /opt/resume
  COPY --dir . ./
  RUN /action/lib/linter.sh

build:
  FROM ghcr.io/xu-cheng/texlive-full:20220701
  WORKDIR /opt/resume
  COPY --dir src ./
  RUN latexmk \
    -cd \
    -lualatex \
    --file-line-error \
    --halt-on-error \
    --interaction=nonstopmode \
    -recorder \
    -output-directory=/opt/resume \
    /opt/resume/src/resume.tex
  SAVE ARTIFACT ./resume.pdf AS LOCAL ./resume.pdf
