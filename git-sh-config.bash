
# CONFIG ==============================================================

# load gitconfig [alias] section as top-level aliases.
_git_import_aliases

# source the system-wide rc file
[ -r /etc/gitshrc ] && . /etc/gitshrc

# source the user's rc file
[ -r ~/.gitshrc ] && . ~/.gitshrc
