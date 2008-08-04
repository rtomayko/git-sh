SHELL = /bin/sh
PREFIX = /usr/local
EXEC_DIR = $(PREFIX)/bin

all: git-sh

git-sh: git-sh.bash git-completion.bash git-sh-config.bash
	cat $^ > git-sh
	chmod 0755 git-sh

run: git-sh
	./git-sh

install: git-sh
	install -m 0755 git-sh $(EXEC_DIR)

clean:
	rm git-sh
