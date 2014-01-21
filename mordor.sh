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
	echo >&2 "If you deem this a big deal, *please file an issue* at"
	echo >&2 "https://github.com/ArchimedesPi/mordor/issues"
}

# Print an INFO message
infoz() {
	message="[INFO]: $1"
	echo message
}

# Print an ERROR message
errorz() {
	message="[ERROR]: $1"
	echo >&2 message
}

#Print a WARNING message
warningz() {
	message="[WARNING]: $1"
	echo message
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
	# Where does it go / what is is named?
	name="$2"

	####GIT it####
	git clone "$url" "$name"

}

# Wrapper for get_repo()
git_fetch() {
	# Repo
	url="$1"
	# Name to clone to
	name="$2"
	# Directory to save to
	dir="$3"

	# Make a new directory to put it in!
	mkdir -p "$dir"
	cd "$dir"
	
	# Get the repo
	get_repo "$url" "$name"

	# What's it named?
	reponame = `ls`
	cd ..
	
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

# Check if a directory exists
directory_exists() {
	location="$1"
	if [ -d location ]; then
		echo true;
	else
		echo false;
	fi
}

# Get the name of a git repo from a URL
git_repo_name() {
	url="$1"
	echo `basename "$url" .git`
}

# Fancily named wrapper for directory_exists()
check_balrog_installed() {
	location="$1"
	echo `directory_exists "$location"`
}

# Fancily named wrapper for git_repo_name
balrog_name() {
	url="$1"
	echo `git_repo_name "$url"`
}

# Process a parsed URL
# This is the meat of Mordor!
process_parsed_url() {
	infoz "Processing parsed URL..."
	# What prefix (`git&` or `balrog&`)
	case $prefix in
	("git")
		# Git prefix!
		infoz "Normal Git repo / Github gist"
		# What's our URL?
		git_url=`cut_after "$parsed_url" "&" "end"`
		infoz "Fetching from Git ($git_url)"
		# Fetch! BTW put it in .mordor/
		location=`git_fetch "$git_url" "" ".mordor"`
		infoz "Found Orcfile!"
		install_package "$location" "Orcfile"
		
		;;
	("balrog")
		# Get everything after `balrog&`
		postfix=`cut_after "$parsed_url" "&" "end"`
		# Get the repo's URL
		git_url=`echo $postfix | cut -d'^' -f 1`
		# What package does the user want?
		package=`echo $postfix | cut -d'^' -f 2`
		# Check if the Balrog is already downloaded! Make sure it's not hiding/lurking around a corner (;
		is_balrog_installed=`check_balrog_installed $git_url`
		# Do different things if the Balrog's there or not.
		if !is_balrog_installed; then
			# Fetch our Balrog! BTW put it in .mordor/balrogs
			location=`git_fetch "$git_url" "" ".mordor/balrogs"`
		else
			# What's the Balrog's name?
			balrog_name=`balrog_name "$git_url"`
			# Where is it hiding?
			location=".mordor/$balrog_name"
			# Make sure the Balrog is up to date!
			git_pull "$location"
		fi

		# Where *is* that Balrog?
		location="$location/$package"
		# Aaaah. Let's install the package. Load an Orcfile!
		install_package "$location" "Orcfile"
		;;
	(*)
		# This is only called if someone makes a coding mistake! (Me most likely...)
		errorz "Uh-oh... There's been an internal error processing the parser prefix $prefix!"
		file_issue
		;;
	esac
}


# The program!

# Get our <url> option
url="$1"

# Parse it
parsed_url=`parse_url_handler "$url"`

# Get the prefix (everything before &)
prefix=`echo $parsed_url | cut -d'&' -f 1`

# OK, now process *that*...
process_parsed_url parsed_url prefix

		
		



	



