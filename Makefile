export SHELL:=/bin/bash
export SHELLOPTS:=$(if $(SHELLOPTS),$(SHELLOPTS):)pipefail:errexit

.ONESHELL:

.PHONY: main
main:
	function tearDown {
		$(MAKE) remove
	}
	trap tearDown EXIT
	$(MAKE) build

.PHONY: test
test:
	function tearDown {
		$(MAKE) remove
	}
	trap tearDown EXIT
	$(MAKE) -k testAll

.PHONY: build
build:
	docker run \
		--name latex \
		-v $$PWD/src:/opt/resume/src:ro \
		ghcr.io/xu-cheng/texlive-full:latest \
		latexmk \
			-cd \
			-lualatex \
			--file-line-error \
			--halt-on-error \
			--interaction=nonstopmode \
			-recorder \
			-output-directory=/tmp \
			/opt/resume/src/resume.tex
	docker cp latex:/tmp/resume.pdf .

.PHONY: remove
remove:
	docker rm -f textidote 2> /dev/null || true
	docker rm -f latex 2> /dev/null || true
	docker rm -f super-linter 2> /dev/null || true

.PHONY: clean
clean:
	rm -f resume.pdf

.PHONY: testAll
testAll: testSuperLinter testTextidote

.PHONY: testSuperLinter
testSuperLinter:
	docker run \
		--rm \
		--name super-linter \
		-e RUN_LOCAL="true" \
		-e MULTI_STATUS="false" \
		-e VALIDATE_ALL_CODEBASE="true" \
		-e VALIDATE_BASH="true" \
		-e VALIDATE_EDITORCONFIG="true" \
		-e VALIDATE_MD="true" \
		-e VALIDATE_YAML="true" \
		-e FILTER_REGEX_EXCLUDE='.*/(CHANGELOG\.md)' \
		-v $$PWD:/tmp/lint \
		github/super-linter:latest

.PHONY: testTextidote
testTextidote:
	docker run \
		--rm \
		--name textidote \
		-v $$PWD:/textidote \
		gokhlayeh/textidote:latest \
		/textidote/src/resume.tex /textidote plain "" 0
