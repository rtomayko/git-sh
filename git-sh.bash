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
# command, kick off a new shell and source us.
[ "$0" = 'bash' ] ||
exec /usr/bin/env bash --rcfile "$0" "$@"

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
	'bundle                stdcmpl'
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
	'difftool       alias'
	'fetch          alias  stdcmpl'
	'format-patch   alias  stdcmpl'
	'fsck           alias'
	'gc             alias  stdcmpl'
	'gui            alias'
	'hash-object    alias'
	'init           alias'
	'instaweb       alias'
	'log            alias  logcmpl'
	'lost-found     alias'
	'ls-files       alias'
	'ls-remote      alias  stdcmpl'
	'ls-tree        alias  stdcmpl'
	'merge          alias  stdcmpl'
	'merge-base     alias  stdcmpl'
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
	'shortlog       alias  stdcmpl'
	'show           alias  stdcmpl'
	'show-branch    alias  logcmpl'
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

# Create aliases for everything defined in the gitconfig [alias] section.
_git_import_aliases () {
	eval "$(
		git config --get-regexp 'alias\..*' |
		sed 's/^alias\.//'                  |
		while read key command
		do
			if expr -- "$command" : '!' >/dev/null
			then echo "alias $key='git $key'"
			else echo "gitalias $key=\"git $command\""
			fi
		done
	)"
}

# PROMPT =======================================================================

PS1='`_git_headname``_git_upstream_state`!`_git_repo_state``_git_workdir``_git_dirty``_git_dirty_stash`> '

ANSI_RESET="\001$(git config --get-color "" "reset")\002"

# detect whether the tree is in a dirty state.
_git_dirty() {
	if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
		return 0
	fi
	local dirty_marker="`git config gitsh.dirty 2>/dev/null || echo ' *'`"

	if ! git diff --quiet 2>/dev/null ; then
		_git_apply_color "$dirty_marker" "color.sh.dirty" "red"
	elif ! git diff --staged --quiet 2>/dev/null ; then
		_git_apply_color "$dirty_marker" "color.sh.dirty-staged" "yellow"
	else
		return 0
	fi
}

# detect whether any changesets are stashed
_git_dirty_stash() {
	if ! git rev-parse --verify refs/stash >/dev/null 2>&1; then
		return 0
	fi
	local dirty_stash_marker="`git config gitsh.dirty-stash 2>/dev/null || echo ' $'`"
	_git_apply_color "$dirty_stash_marker" "color.sh.dirty-stash" "red"
}

# detect the current branch; use 7-sha when not on branch
_git_headname() {
	local br=`git symbolic-ref -q HEAD 2>/dev/null`
	[ -n "$br" ] &&
		br=${br#refs/heads/} ||
		br=`git rev-parse --short HEAD 2>/dev/null`
	_git_apply_color "$br" "color.sh.branch" "yellow reverse"
}

# detect the deviation from the upstream branch
_git_upstream_state() {
	local p=""

	# Find how many commits we are ahead/behind our upstream
	local count="$(git rev-list --count --left-right "@{upstream}"...HEAD 2>/dev/null)"

	# calculate the result
	case "$count" in
		"") # no upstream
			p="" ;;
		"0	0") # equal to upstream
			p=" u=" ;;
		"0	"*) # ahead of upstream
			p=" u+${count#0	}" ;;
		*"	0") # behind upstream
			p=" u-${count%	0}" ;;
		*) # diverged from upstream
			p=" u+${count#*	}-${count%	*}" ;;
	esac

	_git_apply_color "$p" "color.sh.upstream-state" "yellow bold"
}

# detect working directory relative to working tree root
_git_workdir() {
	subdir=`git rev-parse --show-prefix 2>/dev/null`
	subdir="${subdir%/}"
	workdir="${PWD%/$subdir}"
	_git_apply_color "${workdir/*\/}${subdir:+/$subdir}" "color.sh.workdir" "blue bold"
}

# detect if the repository is in a special state (rebase or merge)
_git_repo_state() {
	local git_dir="$(git rev-parse --show-cdup 2>/dev/null).git"
	if test -d "$git_dir/rebase-merge" -o -d "$git_dir/rebase-apply"; then
		local state_marker="(rebase)"
	elif test -f "$git_dir/MERGE_HEAD"; then
		local state_marker="(merge)"
    elif test -f "$git_dir/CHERRY_PICK_HEAD"; then
        local state_marker="(cherry-pick)"
	else
		return 0
	fi
	_git_apply_color "$state_marker" "color.sh.repo-state" "red"
}

# determine whether color should be enabled. this checks git's color.ui
# option and then color.sh.
_git_color_enabled() {
	[ `git config --get-colorbool color.sh true` = "true" ]
}

# apply a color to the first argument
_git_apply_color() {
	local output="$1" color="$2" default="$3"
	if _git_color_enabled ; then
		color=`_git_color "$color" "$default"`
		echo -ne "${color}${output}${ANSI_RESET}"
	else
		echo -ne "$output"
	fi
}

# retrieve an ANSI color escape sequence from git config
_git_color() {
	local color
	color=`git config --get-color "$1" "$2" 2>/dev/null`
	[ -n "$color" ] && echo -ne "\001$color\002"
}

# HELP ========================================================================

_help_display() {
	local name value
	# show git's inbuilt help, after some tweaking...
	git --help | grep -v "See 'git help"

	# show aliases defined in ~/.gitconfig
	echo "Command aliases:"
	git config --get-regexp 'alias\..*' |
	sed 's/^alias\.//'                  |
	sort                                |
	while read name value
	do printf "   %-10s %-65s\n" "$name" "$value"
	done

	printf "\nSee 'help COMMAND' for more information on a specific command.\n"
}

help() {
	local _git_pager=$(git config core.pager)
	if [ $# = 1 ];
	then git help $1
	else (_help_display | ${_git_pager:-${PAGER:-less}})
	fi
}
complete -o default -o nospace -F _git help

# vim: tw=80 noexpandtab
