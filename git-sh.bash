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


# create aliases and configure bash completion for most porcelain commands

_git_cmd_cfg=(
	'add            alias'
	'am             alias  stdcmpl'
	'annotate       alias'
	'apply          alias  stdcmpl'
	'archive        alias'
	'bisect         alias  stdcmpl'
	'blame          alias'
	'branch         alias  stdcmpl'
	'bundle         alias  stdcmpl'
	'cat-file       alias'
	'checkout       alias  stdcmpl'
	'cherry         alias  stdcmpl'
	'cherry-pick    alias  stdcmpl'
	'clean          alias'
	'clone          alias'
	'commit         alias  stdcmpl'
	'config         alias  stdcmpl'
	'describe       alias  stdcmpl'
	'diff           alias  stdcmpl'
	'fetch          alias  stdcmpl'
	'format-patch   alias  stdcmpl'
	'fsck           alias'
	'gc             alias  stdcmpl'
	'gui            alias'
	'init           alias'
	'instaweb       alias'
	'log            alias  logcmpl'
	'lost-found     alias'
	'ls-files       alias'
	'ls-remote      alias  stdcmpl'
	'ls-tree        alias  stdcmpl'
	'merge          alias  stdcmpl'
	'merge-base            stdcmpl'
	'mergetool      alias'
	'mv             alias'
	'name-rev              stdcmpl'
	'patch-id       alias'
	'peek-remote    alias'
	'prune          alias'
	'pull           alias  stdcmpl'
	'push           alias  stdcmpl'
	'quiltimport    alias'
	'rebase         alias  stdcmpl'
	'remote         alias  stdcmpl'
	'repack         alias'
	'repo-config    alias'
	'request-pull   alias'
	'reset          alias  stdcmpl'
	'rev-list       alias'
	'rev-parse      alias'
	'revert         alias'
	'rm             alias'
	'send-email     alias'
	'send-pack      alias'
	'shortlog              stdcmpl'
	'show           alias  stdcmpl'
	'show-branch           logcmpl'
	'stash          alias  stdcmpl'
	'status         alias'
	'stripspace     alias'
	'submodule      alias  stdcmpl'
	'svn            alias'
	'symbolic-ref   alias'
	'tag            alias  stdcmpl'
	'tar-tree       alias'
	'var            alias'
	'whatchanged    alias  logcmpl'
)

for cfg in "${_git_cmd_cfg[@]}" ; do
	read cmd opts <<< $cfg
	for opt in $opts ; do
		case $opt in
			alias)   alias $cmd="git $cmd" ;;
			stdcmpl) complete -o default -o nospace -F _git_${cmd//-/_} $cmd ;;
			logcmpl) complete -o default -o nospace -F _git_log         $cmd ;;
		esac
	done
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
