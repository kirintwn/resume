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

.PHONY: clean
clean:
	rm -f resume.pdf

.PHONY: testAll
testAll: testTextidote

.PHONY: testTextidote
testTextidote:
	docker run \
		--name textidote \
		-v $$PWD:/textidote \
		gokhlayeh/textidote:latest \
		/textidote/src/resume.tex /textidote plain "" 0
