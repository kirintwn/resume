all:
  BUILD +test
  BUILD +build

test:
  BUILD +test-super-linter
  BUILD +test-textidote

test-super-linter:
  FROM github/super-linter:slim-v4.5.0
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

test-textidote:
  FROM gokhlayeh/textidote:v4.1
  WORKDIR /opt/resume
  COPY --dir src .textidote dict.txt ./
  RUN /entrypoint.sh /opt/resume/src/resume.tex /opt/resume plain "" 0

build:
  FROM ghcr.io/xu-cheng/texlive-full:20210701
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
