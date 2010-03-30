SHELL    = /bin/sh
DESTDIR  =
PREFIX   = $(DESTDIR)/usr/local
EXEC_DIR = $(PREFIX)/bin
PROGRAM  = git-sh

all: $(PROGRAM)

$(PROGRAM): git-sh.bash git-completion.bash git-sh-config.bash
	cat $^ > $@
	chmod 0755 $@

git-sh.1.roff: git-sh.1.ronn
	ronn $^ > $@

git-sh.1.html: git-sh.1.ronn
	ronn -5 $^ > $@

doc: git-sh.1.roff git-sh.1.html

run: all
	./$(PROGRAM)

install:
	install -c -m 0755 ./$(PROGRAM) $(EXEC_DIR)

clean:
	$(RM) $(PROGRAM)
	$(MAKE) -C site clean

.PHONY: run install site clean
