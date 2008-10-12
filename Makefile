SHELL    = /bin/sh
DESTDIR  =
PREFIX   = $(DESTDIR)/usr/local
EXEC_DIR = $(PREFIX)/bin
PROGRAM  = git-sh

.PHONY: all
all: $(PROGRAM)

$(PROGRAM): git-sh.bash git-completion.bash git-sh-config.bash
	cat $^ > $@
	chmod 0755 $@

.PHONY: run
run: all
	./$(PROGRAM)

.PHONY: install
install: $(PROGRAM)
	install -m 0755 $^ $(EXEC_DIR)

.PHONY: site
site:
	$(MAKE) -C site

.PHONY: clean
clean:
	$(RM) $(PROGRAM)
	$(MAKE) -C site clean
