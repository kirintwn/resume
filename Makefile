CC = xelatex

resume: resume.tex
	$(CC) $<
test: resume.tex
	textidote $<
clean:
	rm *.pdf *.log *.out *.aux
