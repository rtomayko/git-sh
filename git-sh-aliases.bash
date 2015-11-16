#!/bin/bash
# These are the standard set of aliases enabled by default in all
# git-sh sessions. Aliases defined in the gitconfig [alias] section override
# these.


gitalias a='git add'
gitalias st='git status'
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
gitalias co='git commit'
gitalias chpick='git cherry-pick'

# git add and the staging area
gitalias a='git add'
gitalias aa='git add --update'          # mnemonic: "add all"
gitalias st='git status -s'
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
gitalias peek='git log --patch --format=full --max-count=1'

# git fetch
gitalias f='git fetch'
gitalias pl='git pull'          # mnemonic: pull merge
gitalias pr='git pull --rebase' # mnemonic: pull rebase
gitalias ph='git push'          # mnemonic: pull merge


# git diff
gitalias d='git diff'
gitalias ds='git diff --stat'    # mnemonic: "diff stat"

# git reset
gitalias hard='git reset --hard'
gitalias soft='git reset --soft'
gitalias scrap='git checkout HEAD'

# hub pass-through aliases for new commands
which hub > /dev/null && {
    gitalias fork='hub fork'
    gitalias pull-request='hub pull-request'
    gitalias create='hub create'
    gitalias browse='hub browse'
    gitalias compare='hub compare'
}

# mv handler function
# Smartly directs files to 'git mv' or system 'mv' command based on whether they are tracked or not
function git_mv {
	for f in "$@"; do
		if [[ $(echo "$f" | head -c 1) = "-" ]] ; then
			# Save command option arguments
			args="$args $f"
		else
			# Process file arguments, but skip over last arg (move destination)
			if [[ "$f" != "${@: -1}" ]] ; then
				if [[ -z $(git ls-files "$f" --error-unmatch 2> /dev/null) ]] ; then
					# Send untracked files to bash mv command
					command mv $args "$f" "${@: -1}"
				else
					# Send tracked files to git mv command
					git mv $args "$f" "${@: -1}"
				fi
			fi
		fi
	done
	unset args
}
alias mv='git_mv'

# rm handler function
# Smartly directs files to 'git rm' or system 'rm' command based on whether they are tracked or not
function git_rm {
	for f in "$@"; do
		if [[ $(echo "$f" | head -c 1) = "-" ]] ; then
			# Save command option arguments
			args="$args $f"
		else
			# Process file arguments
			if [[ -z $(git ls-files "$f" --error-unmatch 2> /dev/null) ]] ; then
				# Send untracked files to bash mv command
				command rm $args "$f"
			else
				# Send tracked files to git mv command
				git rm $args "$f"
			fi
		fi
	done
	unset args
}
alias rm='git_rm'
