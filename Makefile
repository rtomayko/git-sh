SHELL    = /bin/sh
DESTDIR  =
PREFIX   = $(DESTDIR)/usr/local

execdir  = $(PREFIX)/bin
datadir  = $(PREFIX)/share
mandir   = $(datadir)/man

PROGRAM  = git-sh
SOURCES  = git-sh.bash git-completion.bash \
           git-sh-aliases.bash git-sh-config.bash
RONN     = ronn --date=2010-03-30 \
                --organization='Ryan Tomayko'

all: $(PROGRAM)

$(PROGRAM): $(SOURCES)
	rm -f $@
	cat $(SOURCES) > $@+
	bash -n $@+
	mv $@+ $@
	chmod 0755 $@

git-sh.1.roff: git-sh.1.ronn
	$(RONN) $^ > $@

git-sh.1.html: git-sh.1.ronn
	$(RONN) -5 $^ > $@

doc: git-sh.1.roff git-sh.1.html

run: all
	./$(PROGRAM)

install: $(PROGRAM)
	install -d "$(execdir)"
	install -m 0755 $(PROGRAM) "$(execdir)/$(PROGRAM)"
	install -d "$(mandir)/man1"
	install -m 0644 git-sh.1.roff "$(mandir)/man1/git-sh.1"

clean:
	rm -f $(PROGRAM)
	rm -f git-sh.1.html

pages: git-sh.1.html
	cp $^ pages/$^

.PHONY: run install site clean pages
