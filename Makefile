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

site/index.html: README.markdown site/header.html site/footer.html
	cat < site/header.html > site/index.html
	markdown < README.markdown >> site/index.html
	cat < site/footer.html >> site/index.html

site: site/index.html

publish: site/index.html
	ssh gus@tomayko.com 'mkdir -p /src/git-sh'
	scp -p site/index.html gus@tomayko.com:/src/git-sh/

clean:
	rm git-sh site/index.html
