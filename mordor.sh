#!/bin/bash
# This is Mordor, the simplistic package manager
# See the docs/ folder for more info
# You'll probably want to try Sauron first in most cases. He's the king! (;
# Otherwise, ring one of the Balrogs up. They'll be happy to help!
# If none of that works, just contact the *issue tracker*. It's even more evil than Sauron (;
# Just joking. https://github.com/ArchimedesPi/mordor/issues
# Feel free to do pull requests, I'm *very* likely to merge them (:
# So fork, add your cool bell/whistle, pull request, and see that same bell/whistle upstream!

# Prints stuff about filing an issue at Github
file_issue() {
	echo >&2 "$(tput setaf 1)If you deem this a big deal, *please file an issue* at"
	echo >&2 "https://github.com/ArchimedesPi/mordor/issues$(tput sgr 0)"
}

# Print an INFO message
infoz() {
	message="$(tput setaf 2)[INFO]:$(tput sgr 0) $1"
	echo $message
}

# Print an ERROR message
errorz() {
	message="[ERROR]: $1"
	echo >&2 $message
}

#Print a WARNING message
warningz() {
	message="[WARNING]: $1"
	echo $message
}

# Everything-After cutter
cut_after() {
	# Our string
	str="$1"
	# Our delimiter
	del="$2"
	# Which end?
	# front *or* end
	pos="$3"

	# Split *all* the things!
	case $str in
  		(*"$sep"*)
    			front=${str%%"$del"*}
    			end=${str#*"$del"}
    			;;
  		(*)
    			front=$str
    			end=
    			;;
	esac
	
	# Which end?
	case $pos in
		("front")
			echo "$front"
			;;
		("end")
			echo "$end"
			;;
		(*)
			errorz "Incorrect positional call to cut_after() !!!"
			file_issue
			exit 1
			;;
	esac
}


# Get a repo from git!
get_repo() {
	# Our url
	url="$1"

	####GIT it####
	# Redirect output to /dev/null !!!
	git clone "$url" > /dev/null 2>&1

}

# Wrapper for get_repo()
git_fetch() {
	# Repo
	url="$1"
	# Directory to save to
	dir="$2"

	# Make a new directory to put it in!
	mkdir -p "$dir"
	pushd "$dir" > /dev/null
	
	# Get the repo

	get_repo $url

	# What's it named?
	reponame=`basename "$url" .git`

	popd > /dev/null
	
	echo "$dir/$reponame"
}


# Parse a Gist url
# parse_gist <id>
parse_gist() {
	# The gist ID
	id="$1"

	# Example gist structure: https://gist.github.com/7781902.git
	# For the gist https://gist.github.com/ArchimedesPi/7781902

	# So it's really simple:
	
	git_url="https://gist.github.com/$id.git"
	echo "$git_url"
}

# Called on the <url> parameter
parse_url_handler() {
	# The <url> parameter
	url="$1"
	
	# What's the prefix? (`gist:`, `git:`, `balrog:`, `sauron:`)
	prefix=`echo $url | cut -d':' -f 1`

	if [[ $prefix == gist ]] ; then
		# Prefix is gist
		# Get the Gist ID
		gistid=`echo $url | cut -d':' -f 2`
		# Parse the Gist ID into a url
		giturl=`parse_gist "$gistid"`
		# 'Return' the Git url 
		echo "git&$giturl"
		return
	elif [[ $prefix == git ]] ; then
		# Prefix is git
		# Get the Git URL
		giturl=`cut_after "$url" ":" "end"`
		# 'Return' the Git url
		echo "git&$giturl"
		return
	elif [[ $prefix == sauron ]] ; then
		# The prefix is sauron
		# Set the Git url to the Sauron repo url
		giturl='https://github.com/ArchimedesPi/sauron.git'
		# What package?
		package=`echo $url | cut -d':' -f 2`
		# 'Return' as a Balrog
		echo "balrog&$giturl^$package"
		return
	elif [[ $prefix == balrog ]] ; then
		# The prefix is balrog
		# Get Git url, it's after ':'
		giturl=`cut_after "$url" ":" "end"`
		# Strip out the package, it's after '@'
		giturl=`echo $giturl | cut -d'@' -f 1`
		# Get the package name
		package=`echo $url | cut -d'@' -f 2`
		# 'Return' as a Balrog
		echo "balrog&$giturl^$package"
		return
	else
		# Uh-oh. This happens if your fingers are numb and can't type properly...
  		errorz "OOOPS! I don't recognize that!"
		file_issue
	fi
}


# Get the name of a git repo from a URL
git_repo_name() {
	url="$1"
	echo `basename "$url" .git`
}

# Fancily named wrapper for git_repo_name
balrog_name() {
	name="$1"
	echo `git_repo_name "$name"`
}

# Do a git pull on a Git repo
git_pull() {
	location="$1"
	pushd "$location" > /dev/null
	git pull
	popd > /dev/null
}

# Process a parsed URL
# This is a big deal - It's the first part that *does things*!
process_parsed_url() {
	infoz "Processing parsed URL..."
	# What prefix (`git&` or `balrog&`)
	case $prefix in
	("git")
		# Git prefix!
		infoz "Normal Git repo / Github gist"
		# What's our URL?
		git_url=`cut_after "$parsed_url" "&" "end"`
		# What's the name of the Git repo?
		repo_name=`git_repo_name "$git_url"`
		infoz "This repo is named: $(tput setaf 2)$repo_name$(tput sgr 0)"
		# Check if it's downloaded already...
		if [[ ! -d ".mordor/$repo_name" ]]; then
			# Fetch the repo
			infoz "Fetching from Git $(tput setaf 2)($git_url)$(tput sgr 0)"
			# Fetch! BTW put it in .mordor/
			location=`git_fetch "$git_url" ".mordor"`
			infoz "The repo is in $(tput setaf 6)$location$(tput sgr 0)"
		else
			# Where's the repo?
			location=".mordor/$repo_name"
			infoz "The repo is in $(tput setaf 6)$location$(tput sgr 0)"
			infoz "Updating repo..."
			git_pull $location
		fi

		infoz "Found Orcfile!"
		infoz "in directory $location"
		install_package "$location" "Orcfile.sh"
		
		;;
	("balrog")
		# It's a balrog!
		infoz "Just a Balrog!"
		# Get everything after `balrog&`
		postfix=`cut_after "$parsed_url" "&" "end"`
		# Get the repo's URL
		git_url=`echo $postfix | cut -d'^' -f 1`
		infoz "Balrog URL: $git_url"
		# What package does the user want?
		package=`echo $postfix | cut -d'^' -f 2`
		infoz "Selecting package \`$package\`"
		# What's the Balrog's name?
		balrog_name=`balrog_name "$git_url"`
		# Check if the Balrog is already downloaded! Make sure it's not hiding/lurking around a corner (;
		if [[ ! -d ".mordor/$balrog_name" ]]; then
			# Fetch our Balrog! BTW put it in .mordor/balrogs
			infoz "Fetching Balrog!"
			location=`git_fetch "$git_url" ".mordor/balrogs"`
		else
			# What's the Balrog's name?
			infoz "This Balrog is named \"$balrog_name\""
			# Where is it hiding?
			location=".mordor/$balrog_name"
			infoz "The Balrog is in $location"
			# Make sure the Balrog is up to date!
			infoz "Updating Balrog..."
			git_pull "$location"
		fi

		# Where *is* that Balrog?
		# This combines the Balrog's location with the *package name*.
		location="$location/$package"

		# Aaaah. Let's install the package. Load an Orcfile!
		install_package "$location" "Orcfile.sh"
		;;
	(*)
		# This is only called if someone makes a coding mistake! (Me most likely...)
		errorz "Uh-oh... There's been an internal error processing the parser prefix $prefix!"
		file_issue
		;;
	esac
}


# The Moste Importante Bitte
# install_package is *recursive*, that is, it looks at a package, checks dependancies, and calls itself on those dependancies!
install_package() {
	infoz "Installing package..."
	# Path to folder with Orcfile
	location="$1"

	# Filename
	filename="$2"

	# Combine the location and the filename!
	orcfile="$location/$filename"
	infoz "Orcfile location: $(tput setaf 2)$(tput setab 5)$orcfile$(tput sgr 0)"

	# What's the package name?
	name=`head --lines=10 "$orcfile" | grep -oP "(?<=#name:).*?(?=;)"`
	infoz "Package name: $(tput setaf 4)$name$(tput sgr 0)"

	# What's the package description?
	description=`head --lines=10 "$orcfile" | grep -oP "(?<=#description:).*?(?=;)"`
	infoz "Package description: $(tput setaf 4)$description$(tput sgr 0)"

	# What version of the package?
	version=`head --lines=10 "$orcfile" | grep -oP "(?<=#version:).*?(?=;)"`
	infoz "Package version: $(tput setaf 4)$version$(tput sgr 0)"

	# What packages does this package depend on?
	dependancies=`head --lines 10 "$orcfile" | grep -oP "(?<=#dependancies:).*?(?=;)"`

	if [[ ! ${#dependancies[@]} -eq 0 ]]; then
		# We have dependancies!

		infoz "This package depends on:"
		for dependancy in ${dependancies[@]}; do
			infoz "${dependancy}"
		done

		for dependancy in ${dependancies[@]}; do
			infoz "Installing dependancy ${dependancy}"

			parsed_url_dependancy_=`parse_url_handler "${dependancy}"`
			infoz "Parsed URL to $(tput setaf 6)$parsed_url_dependancy_$(tput sgr 0)"

			# Get the prefix (everything before &)
			prefix_dependancy_=`echo $parsed_url_dependancy_ | cut -d'&' -f 1`
			infoz "Prefixed with $(tput setaf 6)$prefix_dependancy_$(tput sgr 0)"

			# OK, now process *that*...
			process_parsed_url parsed_url_dependancy_ prefix_dependancy_

			infoz "$(tput smso)$(tput smul)$(tput rev)$(tput setaf 0)$(tput setab 7)DONE INSTALLING DEPENDANCY!!!$(tput sgr 0)"
		done
	elif [[ ${#dependancies[@]} -eq 0 ]]; then
		infoz "$(tput setaf 4)Nothing!$(tput sgr 0)"
	else
		errorz "Uh-oh. This shouldn't happen! Error in install_package()! Error #14!"
		file_issue
	fi

	# Do it.
	# Just do it.
	source "$orcfile"
}

# The program!

# Get our <url> option
url="$1"

# Parse it
parsed_url=`parse_url_handler "$url"`
infoz "Parsed URL to $(tput setaf 6)$parsed_url$(tput sgr 0)"

# Get the prefix (everything before &)
prefix=`echo $parsed_url | cut -d'&' -f 1`
infoz "Prefixed with $(tput setaf 6)$prefix$(tput sgr 0)"

# OK, now process *that*...
process_parsed_url parsed_url prefix

infoz "$(tput smso)$(tput smul)$(tput rev)$(tput setaf 0)$(tput setab 7)DONE!!!$(tput sgr 0)"