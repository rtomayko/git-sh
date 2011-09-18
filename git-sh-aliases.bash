#!/bin/bash
# These are the standard set of aliases enabled by default in all
# git-sh sessions. Aliases defined in the gitconfig [alias] section override
# these.

gitalias a='git add'
gitalias b='git branch'
gitalias c='git checkout'
gitalias d='git diff'
gitalias f='git fetch --prune'
gitalias k='git cherry-pick'
gitalias l='git log --pretty=oneline --abbrev-commit'
gitalias n='git commit --verbose --amend'
gitalias r='git remote'
gitalias s='git commit --dry-run --short'
gitalias t='git diff --cached'

# git add and the staging area
gitalias a='git add'
gitalias aa='git add --update'          # mnemonic: "add all"
gitalias stage='git add'
gitalias ap='git add --patch'
gitalias p='git diff --cached'          # mnemonic: "patch"
gitalias unstage='git reset HEAD'

# commits and history
gitalias ci='git commit --verbose'
gitalias ca='git commit --verbose --all'
gitalias amend='git commit --verbose --amend'
gitalias n='git commit --verbose --amend'
gitalias k='git cherry-pick'
gitalias re='git rebase --interactive'
gitalias pop='git reset --soft HEAD^'
gitalias peek='git log -p --max-count=1'

# git fetch
gitalias f='git fetch'
gitalias pm='git pull'          # mnemonic: pull merge
gitalias pr='git pull --rebase' # mnemonic: pull rebase

# git diff
gitalias d='git diff'
gitalias ds='git diff --stat'    # mnemonic: "diff stat"

# git reset
gitalias hard='git reset --hard'
gitalias soft='git reset --soft'
gitalias scrap='git checkout HEAD'
