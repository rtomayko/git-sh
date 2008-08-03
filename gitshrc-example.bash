# (@) ~rtomayko/.gitshrc

alias commit='git commit -v'
alias ci='git commit -v'
alias ca='git commit -a'
alias  n='git commit -v --amend'
complete -o default -o nospace -F _git_commit ci
complete -o default -o nospace -F _git_commit ca
complete -o default -o nospace -F _git_commit n

alias  a='git add'
alias aa='git add -u'
complete -o default -o nospace -F _git_add a
complete -o default -o nospace -F _git_add aa

alias  c='git checkout'
complete -o default -o nospace -F _git_checkout c

alias  f='git fetch'
complete -o default -o nospace -F _git_fetch f

alias  r='git rebase -i HEAD~10'

alias  d='git diff'
alias  p='git diff --cached'
complete -o default -o nospace -F _git_diff d
complete -o default -o nospace -F _git_diff p


alias  s='git status'
complete -o default -o nospace -F _git_status s

alias L='git log'
alias l='git log --pretty=oneline --abbrev-commit'
alias l1='l -n1'
alias l2='l -n2'
alias l5='l -n5'
alias l10='l -n10'
alias ll='l -n10'

complete -o default -o nospace -F _git_log L
complete -o default -o nospace -F _git_log l
complete -o default -o nospace -F _git_log l1
complete -o default -o nospace -F _git_log l2
complete -o default -o nospace -F _git_log l5
complete -o default -o nospace -F _git_log l10
complete -o default -o nospace -F _git_log ll

alias mirror='git reset --hard'
alias unstage='git reset HEAD'
complete -o default -o nospace -F _git_reset mirror
complete -o default -o nospace -F _git_reset unstage

alias stage='git add'
alias queue='git add'
alias amend='git commit -v --amend'
alias pop='git reset --soft HEAD^'
