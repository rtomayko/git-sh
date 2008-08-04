#!/usr/bin/env bash
#
# A customized bash environment suitable for git work.
#
# Copyright (C) 2008 Ryan Tomayko <r@tomayko.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
# Distributed under the GNU General Public License, version 2.0.

# use to install the sh alias
[[ $1 = '--configure' && $# = 1 ]] && {
	set -e
	git config --global alias.sh '!git-sh'
	echo "alias 'sh' added to ~/.gitconfig"
	exit 0
}

# we expect to be sourced into an interactive shell. when executed as a
# command, kick off a new shell and source us. this is a pretty cool hack;
# make it better.
[ "$0" = 'bash' ] ||
exec /usr/bin/env bash --rcfile "$@" "$0"

# source the user's .bashrc file
[ -r ~/.bashrc ] && {
	pushd ~
	. .bashrc
	popd
}

# create aliases for most/all git command porcelains.
for cmd in \
	checkout add am annotate apply archive bisect blame branch bundle \
	cat-file checkout cherry cherry-pick clean clone commit config describe \
	diff fetch format-patch fsck gc gui init instaweb log lost-found \
	ls-files ls-remote ls-tree merge mergetool mv patch-id peek-remote prune \
	pull push quiltimport rebase remote repack repo-config request-pull \
	reset rev-list rev-parse revert rm send-email send-pack show stash \
	status stripspace submodule svn symbolic-ref tag tar-tree var \
	whatchanged \
; do
	alias $cmd="git $cmd"
done

# configure bash completion for aliases
for cmd in \
	am apply bisect branch bundle checkout cherry cherry-pick commit \
	describe diff fetch format-patch gc log ls-remote ls-tree merge \
	merge-base name-rev pull push rebase config remote reset shortlog \
	show stash submodule tag \
; do
	complete -o default -o nospace -F _git_${cmd//-/_} $cmd
done
for cmd in show-branch whatchanged ; do
	complete -o default -o nospace -F _git_log $cmd
done

# setup the prompt

git_prompt_setup() {
	br=$(git symbolic-ref HEAD 2>/dev/null)
	br=${br#refs/heads/}
	rel=$(git rev-parse --show-prefix 2>/dev/null)
	rel="${rel%/}"
	loc="${PWD%/$rel}"
}

git_prompt_plain() {
	git_prompt_setup
	PS1="git:$br!${loc/*\/}${rel:+/$rel}> "
}

git_prompt_color() {
	git_prompt_setup
	PS1="${BLACK}${ORANGE_BG}$br${PS_CLEAR}${GREY}!${PS_CLEAR}${LIGHT_BLUE}${loc/*\/}${rel:+/$rel}${PS_CLEAR}${GREY}>${PS_CLEAR} "
}

PROMPT_COMMAND=git_prompt_color

# try to provide a decent help command

_help_display() {
	git --help
	test -r ~/.gitshrc && {
		echo ; echo 'Aliases from ~/.gitshrc'
		perl -ne's/alias // or next; s/=/\t\t\t/; print' ~/.gitshrc
	}
}

help() {
	local _git_pager=$(git config core.pager)
	_help_display | ${_git_pager:-${PAGER:-less}}
}
