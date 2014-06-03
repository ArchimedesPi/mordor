#!/usr/bin/env bash
# This is Mordor, the simplistic package manager
# See the docs/ folder for more info
# Feel free to do pull requests, I'm *very* likely to merge them (:
# So fork, add your cool bell/whistle, pull request, and see that same bell/whistle upstream!

############################
### Bootstrap the script ###
############################

# Patch in some *possibly desynchronized* functions from `files`
# We'll overwrite them with (possibly up-to-date) versions later
absolute_file_containingdir() {
	local dirty_path="$1"
	pushd `dirname $dirty_path` > /dev/null
	local enclosing_dir_path=`pwd -P`
	popd > /dev/null

	echo "$enclosing_dir_path"
}

absolute_path() {
	local dirty_path="$1"
	pushd "$dirty_path" > /dev/null
	local clean_path=`pwd -P`
	popd > /dev/null

	echo "$clean_path"
}

##############################
### Load all the libraries ###
##############################
BASEDIR=`absolute_file_containingdir $0`
SCRIPTDIR=`absolute_path "$BASEDIR/../util"`

# Just source in all the libraries we need
. $SCRIPTDIR/colors.bash
. $SCRIPTDIR/messaging.bash
. $SCRIPTDIR/text.bash
. $SCRIPTDIR/files.bash
. $SCRIPTDIR/url.bash
. $SCRIPTDIR/git.bash
. $SCRIPTDIR/command.bash

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
  		onoe "OOOPS! I don't recognize that!"
		file_issue
	fi
}


# Fancily named wrapper for git_repo_name
balrog_name() {
	name="$1"
	echo `git_repo_name "$name"`
}

# Process a parsed URL
# This is a big deal - It's the first part that *does things*!
process_parsed_url() {
	ohai "Processing parsed URL..."
	# What prefix (`git&` or `balrog&`)
	case $prefix in
	("git")
		# Git prefix!
		ohai "Normal Git repo / Github gist"
		# What's our URL?
		git_url=`cut_after "$parsed_url" "&" "end"`
		# What's the name of the Git repo?
		repo_name=`git_repo_name "$git_url"`
		ohai "This repo is named: $(tput setaf 2)$repo_name$(tput sgr 0)"
		# Check if it's downloaded already...
		if [[ ! -d ".mordor/$repo_name" ]]; then
			# Fetch the repo
			ohai "Fetching from Git $(tput setaf 2)($git_url)$(tput sgr 0)"
			# Fetch! BTW put it in .mordor/
			location=`git_fetch "$git_url" ".mordor"`
			ohai "The repo is in $(tput setaf 6)$location$(tput sgr 0)"
		else
			# Where's the repo?
			location=".mordor/$repo_name"
			ohai "The repo is in $(tput setaf 6)$location$(tput sgr 0)"
			ohai "Updating repo..."
			# Pull it!
			git_pull $location
		fi

		ohai "Found Orcfile!"
		ohai "in directory $location"
		# Install the package
		install_package "$location" "Orcfile.sh"
		
		;;
	("balrog")
		# It's a balrog!
		ohai "Just a Balrog!"
		# Get everything after `balrog&`
		postfix=`cut_after "$parsed_url" "&" "end"`
		# Get the repo's URL
		git_url=`echo $postfix | cut -d'^' -f 1`
		ohai "Balrog URL: $git_url"
		# What package does the user want?
		package=`echo $postfix | cut -d'^' -f 2`
		ohai "Selecting package \`$package\`"
		# What's the Balrog's name?
		balrog_name=`balrog_name "$git_url"`
		# Check if the Balrog is already downloaded! Make sure it's not hiding/lurking around a corner (;
		if [[ ! -d ".mordor/$balrog_name" ]]; then
			# Fetch our Balrog! BTW put it in .mordor/balrogs
			ohai "Fetching Balrog!"
			location=`git_fetch "$git_url" ".mordor/balrogs"`
		else
			# What's the Balrog's name?
			ohai "This Balrog is named \"$balrog_name\""
			# Where is it hiding?
			location=".mordor/$balrog_name"
			ohai "The Balrog is in $location"
			# Make sure the Balrog is up to date!
			ohai "Updating Balrog..."
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
		onoe "Uh-oh... There's been an internal error processing the parser prefix $prefix!"
		file_issue
		;;
	esac
}


# The Moste Importante Bitte
# install_package is *recursive*, that is, it looks at a package, checks dependancies, and calls itself on those dependancies!
install_package() {
	ohai "Installing package..."
	# Path to folder with Orcfile
	location="$1"

	# Filename
	filename="$2"

	# Combine the location and the filename!
	orcfile="$location/$filename"
	ohai "Orcfile location: $(tput setaf 2)$(tput setab 5)$orcfile$(tput sgr 0)"

	# What's the package name?
	name=`head --lines=10 "$orcfile" | grep -oP "(?<=#name:).*?(?=;)"`
	ohai "Package name: $(tput setaf 4)$name$(tput sgr 0)"

	# What's the package description?
	description=`head --lines=10 "$orcfile" | grep -oP "(?<=#description:).*?(?=;)"`
	ohai "Package description: $(tput setaf 4)$description$(tput sgr 0)"

	# What version of the package?
	version=`head --lines=10 "$orcfile" | grep -oP "(?<=#version:).*?(?=;)"`
	ohai "Package version: $(tput setaf 4)$version$(tput sgr 0)"

	# What packages does this package depend on?
	dependancies=`head --lines 10 "$orcfile" | grep -oP "(?<=#dependancies:).*?(?=;)"`
	dependancies=($dependancies)

	# Let the user know that...
	ohai "This package depends on:"
	if [[ ! ${#dependancies[@]} -eq 0 ]]; then
		# We have dependancies!

		for dependancy in ${dependancies[@]}; do
			ohai "${dependancy}"
		done

		for dependancy in ${dependancies[@]}; do
			ohai "Installing dependancy ${dependancy}"

			parsed_url_dependancy_=`parse_url_handler "${dependancy}"`
			ohai "Parsed URL to $(tput setaf 6)$parsed_url_dependancy_$(tput sgr 0)"

			# Get the prefix (everything before &)
			prefix_dependancy_=`echo $parsed_url_dependancy_ | cut -d'&' -f 1`
			ohai "Prefixed with $(tput setaf 6)$prefix_dependancy_$(tput sgr 0)"

			# OK, now process *that*...
			process_parsed_url parsed_url_dependancy_ prefix_dependancy_

			ohai "$(tput smso)$(tput smul)$(tput rev)$(tput setaf 0)$(tput setab 7)DONE INSTALLING DEPENDANCY!!!$(tput sgr 0)"
		done
	elif [[ ${#dependancies[@]} -eq 0 ]]; then
		# We don't have dependancies!
		ohai "$(tput setaf 4)Nothing!$(tput sgr 0)"
	else
		# Something's wrong. :(
		onoe "Uh-oh. This shouldn't happen! Error in install_package()! Error #14!"
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
ohai "Parsed URL to $(tput setaf 6)$parsed_url$(tput sgr 0)"

# Get the prefix (everything before &)
prefix=`echo $parsed_url | cut -d'&' -f 1`
ohai "Prefixed with $(tput setaf 6)$prefix$(tput sgr 0)"

# OK, now process *that*...
process_parsed_url parsed_url prefix

ohai "$(tput smso)$(tput smul)$(tput rev)$(tput setaf 0)$(tput setab 7)DONE!!!$(tput sgr 0)"