#!/bin/bash
# Example ~/.gitshrc file.

# git commit
gitalias commit='git commit --verbose'
gitalias amend='git commit --verbose --amend'
gitalias ci='git commit --verbose'
gitalias ca='git commit --verbose --all'
gitalias  n='git commit --verbose --amend'

# git add
gitalias  a='git add'
gitalias aa='git add --update'
gitalias ap='git add --patch'

# git checkout
gitalias c='git checkout'

# git fetch
gitalias f='git fetch'

# git rebase
gitalias r='git rebase --interactive HEAD~10'

# git diff
gitalias d='git diff'
gitalias p='git diff --cached'   # mnemonic: "patch"

# git status
alias  s='git status'

# git log
gitalias  L='git log'
gitalias  l='git log --pretty=oneline --abbrev-commit'
gitalias ll='git log --pretty=oneline --abbrev-commit --max-count=15'

# experimental
gitalias mirror='git reset --hard'
gitalias stage='git add'
gitalias unstage='git reset HEAD'
gitalias pop='git reset --soft HEAD^'
gitalias review='git log -p --max-count=1'
