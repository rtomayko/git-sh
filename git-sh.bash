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
[ "$1" = "--configure" ] && {
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
	cd ~
	. .bashrc
	cd $OLDPWD
}

# create aliases for most/all git command porcelains.

alias checkout='git checkout'
alias add='git add'
alias am='git am'
alias annotate='git annotate'
alias apply='git apply'
alias archive='git archive'
alias bisect='git bisect'
alias blame='git blame'
alias branch='git branch'
alias bundle='git bundle'
alias cat-file='git cat-file'
alias checkout='git checkout'
alias cherry='git cherry'
alias cherry-pick='git cherry-pick'
alias clean='git clean'
alias clone='git clone'
alias commit='git commit'
alias config='git config'
alias describe='git describe'
alias diff='git diff'
alias fetch='git fetch'
alias format-patch='git format-patch'
alias fsck='git fsck'
alias gc='git gc'
alias gui='git gui'
alias init='git init'
alias instaweb='git instaweb'
alias log='git log'
alias lost-found='git lost-found'
alias ls-files='git ls-files'
alias ls-remote='git ls-remote'
alias ls-tree='git ls-tree'
alias merge='git merge'
alias mergetool='git mergetool'
alias mv='git mv'
alias patch-id='git patch-id'
alias peek-remote='git peek-remote'
alias prune='git prune'
alias pull='git pull'
alias push='git push'
alias quiltimport='git quiltimport'
alias rebase='git rebase'
alias remote='git remote'
alias repack='git repack'
alias repo-config='git repo-config'
alias request-pull='git request-pull'
alias reset='git reset'
alias rev-list='git rev-list'
alias rev-parse='git rev-parse'
alias revert='git revert'
alias rm='git rm'
alias send-email='git send-email'
alias send-pack='git send-pack'
alias show='git show'
alias stash='git stash'
alias status='git status'
alias stripspace='git stripspace'
alias submodule='git submodule'
alias svn='git svn'
alias symbolic-ref='git symbolic-ref'
alias tag='git tag'
alias tar-tree='git tar-tree'
alias var='git var'
alias whatchanged='git whatchanged'

# configure bash completion for aliases

complete -o default -o nospace -F _git_am am
complete -o default -o nospace -F _git_apply apply
complete -o default -o nospace -F _git_bisect bisect
complete -o default -o nospace -F _git_branch branch
complete -o default -o nospace -F _git_bundle bundle
complete -o default -o nospace -F _git_checkout checkout
complete -o default -o nospace -F _git_cherry cherry
complete -o default -o nospace -F _git_cherry_pick cherry-pick
complete -o default -o nospace -F _git_commit commit
complete -o default -o nospace -F _git_describe describe
complete -o default -o nospace -F _git_diff diff
complete -o default -o nospace -F _git_fetch fetch
complete -o default -o nospace -F _git_format_patch format-patch
complete -o default -o nospace -F _git_gc gc
complete -o default -o nospace -F _git_log log
complete -o default -o nospace -F _git_ls_remote ls-remote
complete -o default -o nospace -F _git_ls_tree ls-tree
complete -o default -o nospace -F _git_merge merge
complete -o default -o nospace -F _git_merge_base merge-base
complete -o default -o nospace -F _git_name_rev name-rev
complete -o default -o nospace -F _git_pull pull
complete -o default -o nospace -F _git_push push
complete -o default -o nospace -F _git_rebase rebase
complete -o default -o nospace -F _git_config config
complete -o default -o nospace -F _git_remote remote
complete -o default -o nospace -F _git_reset reset
complete -o default -o nospace -F _git_shortlog shortlog
complete -o default -o nospace -F _git_show show
complete -o default -o nospace -F _git_stash stash
complete -o default -o nospace -F _git_submodule submodule
complete -o default -o nospace -F _git_log show-branch
complete -o default -o nospace -F _git_tag tag
complete -o default -o nospace -F _git_log whatchanged

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
		printf "\nAliases from ~/.gitshrc\n"
		cat ~/.gitshrc |
		/usr/bin/grep -F alias |
		perl -pe "s/alias //" |
		perl -pe "s/=/\t\t\t/"
	}
}

help() {
	local _git_pager=$(git config core.pager)
	_help_display | ${_git_pager:-${PAGER:-less}}
}
