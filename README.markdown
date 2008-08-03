git-sh
======

A customized bash shell suitable for git work.

The `git-sh` command starts an interactive shell tweaked for heavy git
interaction:

  * Makes all git command porcelains available as top-level command aliases.
  * Custom prompt with branch and current repository
  * Customizable via ~/.gitshrc file (add aliases, change prompt, etc.)
  * Shawn O. Pearce's bash completion support built-in and works with
    aliases.
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

Basic Usage
-----------

I typically change into a git working copy before starting the shell:

    $ cd some-git-repo
    $ git sh
    master!some-git-repo>

The shell's default prompt shows the current branch, bang, and the relative
path to the current working directory from the nearest git working copy.

Most git commands can be executed directly:

    master!some-git-repo> checkout -b new-branch
    new-branch!some-git-repo> log -p
    new-branch!some-git-repo> rebase -i HEAD~10

IMPORTANT: `rm`, `mv`, and `diff` are aliased to their git counterparts.
Qualify the command (e.g., `/bin/rm`) to use system versions.

Customizing
-----------

If the `~/.gitshrc` file exists, it is sourced as the very last thing the
shell does before becoming interactive. I've included my personal
[`~/.gitshrc`][1] in the distribution as an example.

[1]: gitshrc-example.bash "Ryan's ~/.gitshrc file"

Note also that your `~/.bashrc` file is sourced into the shell as well so
any customization made there not explicitly overridden by `git-sh` should
be available.

Help
----

The `help` command shows git's help output followed by a list of custom
aliases from your `~/.gitshrc` file:

    master!some-git-repo> help

License
-------

Copyright (C) 2008 Ryan Tomayko <r@tomayko.com>
Copyright (C) 2006, 2007 Shawn O. Pearce <spearce@spearce.org>

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU General Public License, version 2, as published
by the Free Software Foundation.
