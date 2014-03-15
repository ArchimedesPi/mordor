# Utilities to help with handling Git

# Get a repo from git!
get_repo() {
	# Our url
	local url="$1"

	####GIT it####
	# Redirect output to /dev/null !!!
	git clone "$url" > /dev/null 2>&1

}

# Wrapper for get_repo()
git_fetch() {
	# Repo
	local url="$1"
	# Directory to save to
	local ir="$2"

	# Make a new directory to put it in!
	mkdir -p "$dir"
	pushd "$dir" > /dev/null
	
	# Get the repo

	get_repo $url

	# What's it named?
	local reponame=`basename "$url" .git`

	popd > /dev/null
	
	echo "$dir/$reponame"
}

# Get the name of a git repo from a URL
git_repo_name() {
	local url="$1"
	echo `basename "$url" .git`
}

# Do a git pull on a Git repo
git_pull() {
	local location="$1"
	pushd "$location" > /dev/null
	git pull
	popd > /dev/null
}