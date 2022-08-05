# add these aliases to your .bashrc, and then run `source .bashrc` or restart your shell. don't have a .bashrc? see https://stackoverflow.com/a/32353083/5503076

# git-add-commit-push
# usage: `gacp "commit message"`
# adds all active changes in the repo, commits them all with the provided message, pushes them remotely
# make sure to double-check you don't have changes you don't want to push, and stash them if so, or use gcp
gacp() {
        git add . && git commit -m "$1" && git push
}

# git-commit-push
# usage: `gcp "commit message"`
# commits all added changes (you can run `git status` to see what's added) with the provided message, pushes them remotely
gcp() {
        git commit -m "$1" && git push
}

# git-fetch-latest
# usage: `gfl <branch>`
# fetches and pulls the latest version of the provided branch from origin. great for reviews, or checking out latest master! with no arguments, pulls the latest version of the current branch
gfl() {
	if [ $# -eq 0 ]; then
		git pull
	else
		git fetch && git checkout "$1" && git pull
	fi
}

alias gflm='gfl master'

# git-reset-hard-head
# resets ALL uncommited changes and returns your working tree to the status of the latest commit.
# great if you just want to blow up all your local work and start over, but beware if you did anything you want to keep!
# make sure to commit or stash any needed changes if so
alias grhh='git reset --hard HEAD'

# git-sub-module
# puts all your submodules into a correct state; initializes them if necessary, then updates them to the version your branch calls for
alias gsm='git submodule update --init --recursive'

# git-status
# tells you the current status of your working tree: which files are changed/added/removed and which are/are not staged for commit
alias gs='git status'

# git-diff
# shows you a diff of every file currently changed in the working tree
alias gd='git diff'

# git-checkout-branch
# usage: `gcb PROJECT-12345`
# checks out a new branch with the provided name, off the current commit. will not affect any existing changes in your working tree
gcb() {
        git checkout -b "$1"
}

# git-branch-tag
# usage: `gbt BL_12345.1 PROJECT-42069`
# checks out the commit pointed to by the provided tag (if it exists) and if successful, starts a new branch with the provided branch name
gbt() {
        git checkout tags/$1 -b $2
}

#git-pull-down -- a git pull, but the way it should work all the time
gpd() {
	head="$(git rev-parse --abbrev-ref HEAD)"

	if [[ $(git config "branch.$head.merge") ]]; then #there's already a merge target configured, just pull as normal from there
		git pull
	else
		if [[ $(git ls-remote --heads origin $head) ]]; then #there is an upstream branch existing with the same name as our branch
			git branch --set-upstream-to origin/$head #set merge target to upstream branch with same name
			git pull
		else #fail with explanation
			echo "Branch $head has no upstream or merge target! You will likely have to push first, or manually configure it"
			return 1
		fi
	fi
}
