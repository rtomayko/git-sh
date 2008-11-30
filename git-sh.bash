#!/usr/bin/env bash
#
# A customized bash environment suitable for git work.
#
# Copyright (C) 2008 Ryan Tomayko <http://tomayko.com/>
# Copyright (C) 2008 Aristotle Pagaltzis <http://plasmasturm.org/>
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
	pushd ~ > /dev/null
	. .bashrc
	popd > /dev/null
}


# ALIASES + COMPLETION =========================================================

# gitcomp <alias> <command>
#
# Complete command named <alias> like standard git command named
# <command>. <command> must be a valid git command with completion.
#
# Examples:
#   gitcomplete ci commit
#   gitcomplete c  checkout
gitcomplete() {
	local alias="$1" command="$2"
	complete -o default -o nospace -F _git_${command//-/_} $alias
}

# gitalias <alias>='<command> [<args>...]'
#
# Define a new shell alias (as with the alias builtin) named <alias>
# and enable command completion based on <command>. <command> must be
# a standard non-abbreviated git command name that has completion support.
#
# Examples:
#   gitalias c=checkout
#   gitalias ci='commit -v'
#   gitalias r='rebase --interactive HEAD~10'
gitalias() {
	local alias="${1%%=*}" command="${1#*=}"
	local prog="${command##git }"
	prog="${prog%% *}"
	alias $alias="$command"
	gitcomplete "$alias" "$prog"
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
	'reflog         alias'
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
	'svn            alias  stdcmpl'
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

# PROMPT =======================================================================

COLOR_RESET="\[\033[0;39;49m\]"

_git_prompt_setup() {
	br=$(git symbolic-ref -q HEAD 2>/dev/null)
	if [ -n "$br" ] ; then
		br=${br#refs/heads/}
	else
		br=$(git rev-parse --short HEAD 2>/dev/null)
	fi
	rel=$(git rev-parse --show-prefix 2>/dev/null)
	rel="${rel%/}"
	loc="${PWD%/$rel}"
}

# read the color.sh git config value to determine which variation of prompt
# command to use.
_git_prompt_detect() {
	if git config --get-colorbool color.sh 2>/dev/null ;
	then
		# TODO add "color.sh.THING" config values
		COLOR_BRANCH='\[$(git config --get-color color.branch.current 2>/dev/null)\]'
		COLOR_WORKDIR='\[$(git config --get-color color.diff.meta 2>/dev/null)\]'
		_git_prompt_color
	else
		_git_prompt_plain
	fi
}

_git_prompt_plain() {
	_git_prompt_setup
	PS1="git:$br!${loc/*\/}${rel:+/$rel}> "
}

_git_prompt_color() {
	_git_prompt_setup
	PS1="${COLOR_BRANCH}${br}${COLOR_RESET}!${COLOR_WORKDIR}${loc/*\/}${rel:+/$rel}${COLOR_RESET}> "
}

PROMPT_COMMAND=_git_prompt_detect

# try to provide a decent help command

_help_display() {
	# show git's inbuilt help, after some tweaking...
	git --help |
		grep -v 'usage: git ' |
		sed "s/See 'git help/See 'help/"

	# show aliases from ~/.gitshrc
	[ -r ~/.gitshrc ] && {
		echo ; echo 'Aliases from ~/.gitshrc'
		perl -ne's/(?:git)?alias +// or next; s/=/\t\t\t/; print' ~/.gitshrc
	}
}

help() {
	local _git_pager=$(git config core.pager)
	[ $# = 1 ] &&
		git help $1 ||
		(_help_display | ${_git_pager:-${PAGER:-less}})
}
complete -o default -o nospace -F _git help

# vim: tw=80
