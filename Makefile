SHELL    = /bin/sh
DESTDIR  =
PREFIX   = $(DESTDIR)/usr/local
EXEC_DIR = $(PREFIX)/bin
PROGRAM  = git-sh

all: $(PROGRAM)

$(PROGRAM): git-sh.bash git-completion.bash git-sh-config.bash
	cat $^ > $@
	chmod 0755 $@

run: all
	./$(PROGRAM)

install: $(PROGRAM)
	install -m 0755 $^ $(EXEC_DIR)

site:
	$(MAKE) -C site

clean:
	$(RM) $(PROGRAM)
	$(MAKE) -C site clean

.PHONY: run install site clean
