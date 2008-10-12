PAGES=index.html
SRV_DIR=/src/git-sh
HOST=gus@tomayko.com

.PHONY: all
all: $(PAGES)

%.html: %.tmpl.html %.markdown
	( sed '/^\[CONTENT]$$/,$$d' $< ; Markdown.pl < $*.markdown ; sed '1,/^\[CONTENT]$$/d' $< ) > $@

.PHONY: publish
publish: $(PAGES)
	ssh $(HOST) 'mkdir -p $(SRV_DIR)'
	scp -p $(PAGES) $(HOST):$(SRV_DIR)/

.PHONY: clean
clean:
	$(RM) $(PAGES)
