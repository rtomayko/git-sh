git-sh
======

A customized bash shell suitable for git work.

The `git-sh` command starts an interactive bash shell tweaked for heavy git
interaction:

  * Makes all git command porcelains available as top-level command aliases.
  * Custom prompt with branch and current repository.
  * Shawn O. Pearce's bash completion support built-in.
  * Customizable via `/etc/gitshrc` and `~/.gitshrc` config files (add
    aliases, change prompt, etc.)
  * `gitalias` command for defining shorthand git aliases with completion.
  * Respects `~/.bashrc` and `~/.inputrc` configuration.

Installation
------------

I suppose we can assume you have git installed:

    $ git clone git://github.com/rtomayko/git-sh.git
    $ cd git-sh
    $ make
    $ sudo make install

The `make install` command copies the `git-sh` executable to
`/usr/local/bin`. Use the `PREFIX` environment variable to specify
a different location (or just copy and chmod the `git-sh` file).

If you'd like to be able to run `git sh` instead of `git-sh`, use
the following to add a command alias in `~/.gitconfig`:

    $ git-sh --configure
    $ git sh

The git-sh prompt includes ANSI color support but it's disabled by default
(unless the git `color.ui` option is enabled). To enable git-sh's prompt
colors explicitly, set the `color.sh` config value to `auto`:

    $ git config --global color.sh auto

The prompt colors can be customized by setting the `color.sh.branch`,
`color.sh.workdir`, and `color.sh.dirty` git config values:

    $ git config --global color.sh.branch 'yellow reverse'
    $ git config --global color.sh.workdir 'blue bold'
    $ git config --global color.sh.dirty 'red'

See [colors in git](http://scie.nti.st/2007/5/2/colors-in-git) for
information on customizing.

Basic Usage
-----------

I typically change into a git working copy before starting the shell:

    $ cd some-git-repo
    $ git sh
    master!some-git-repo>

The shell's default prompt shows the current branch, a bang, and the
relative path to the current working directory from the nearest git working
copy.

Most git commands can be executed directly:

    master!some-git-repo> checkout -b new-branch
    new-branch!some-git-repo> log -p
    new-branch!some-git-repo> rebase -i HEAD~10

IMPORTANT: `rm`, `mv`, and `diff` are aliased to their git counterparts.
Use the `command` command (eg. `command rm`) or qualify the command
(e.g. `/bin/rm`) to use system versions.

Customizing
-----------

The `/etc/gitshrc` and `~/.gitshrc` files are sourced (in that order)
immediately before the shell becomes interactive.  An [example `gitshrc`
file][1] is include in the distribution as an example.

[1]: http://github.com/rtomayko/git-sh/blob/master/gitshrc-example.bash
     "Ryan's ~/.gitshrc file"

Note also that your `~/.bashrc` file is sourced into the shell before either
`/etc/gitshrc` or `~/.gitshrc`, so any base bash customizations not
explicitly overridden by `git-sh` should be available.

Help
----

The `help` command shows git's help output followed by a list of custom
aliases from your `~/.gitshrc` file:

    master!some-git-repo> help

License
-------

Copyright (C) 2008 [Ryan Tomayko](http://tomayko.com/)  
Copyright (C) 2008 [Aristotle Pagaltzis](http://plasmasturm.org/)  
Copyright (C) 2006, 2007 [Shawn O. Pearce](mailto:spearce@spearce.org)

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License, version 2, as published
by the Free Software Foundation.
