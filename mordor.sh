#!/bin/bash

# Prints stuff about filing an issue at Github
file_issue() {
	echo >&2 "If you deem this a big deal, *please file an issue* at"
	echo >&2 "https://github.com/ArchimedesPi/mordor/issues"
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
	
	case $pos in
		("front")
			echo "$front"
			;;
		("end")
			echo "$end"
			;;
		(*)
			echo >&2 "Incorrect positional call to cut_after() !!!"
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

	mkdir -p "$dir"
	cd "$dir"
	
	get_repo "$url" "$name"

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
	
	prefix=`echo $url | cut -d':' -f 1`

	if [[ $prefix == gist ]] ; then
		gistid=`echo $url | cut -d':' -f 2`
		giturl=`parse_gist "$gistid"`
		echo "git&$giturl"
		return
	elif [[ $prefix == git ]] ; then
		giturl=`cut_after "$url" ":" "end"`
		echo "git&$giturl"
		return
	elif [[ $prefix == sauron ]] ; then
		giturl='https://github.com/ArchimedesPi/sauron.git'
		package=`echo $url | cut -d':' -f 2`
		echo "balrog&$giturl^$package"
		return
	elif [[ $prefix == balrog ]] ; then
		giturl=`cut_after "$url" ":" "end"`
		giturl=`echo $giturl | cut -d'@' -f 1`
		package=`echo $url | cut -d'@' -f 2`
		echo "balrog&$giturl^$package"
		return
	else
  		echo >&2 "OOOPS! I don't recognize that!"
		file_issue
	fi
}

# Process a parsed URL
# This is the meat of Mordor!
process_parsed_url() {
	case $prefix in
	("git")
		git_url=`cut_after "$parsed_url" "&" "end"`
		location=`git_fetch "$git_url" "" ".mordor"`
		install_package "$location" "Orcfile"
		;;
	("balrog")
		postfix=`cut_after "$parsed_url" "&" "end"`
		git_url=`echo $postfix | cut -d'^' -f 1`
		package=`echo $postfix | cut -d'^' -f 2`
		is_balrog_installed=`check_balrog_installed $git_url`
		if !is_balrog_installed; then
			location=`git_fetch "$git_url" "" ".mordor/balrogs"`
		else
			balrog_name=`balrog_name "$git_url"`
			location=".mordor/$balrog_name"
			git_pull "$location"
		fi
		
		location="$location/$package"
		install_package "$location" "Orcfile"
		;;
	(*)
		echo >&2 "Uh-oh... There's been an internal error processing the parser prefix $prefix!"
		file_issue
		;;
	esac
}


# The program!

url="$1"

parsed_url=`parse_url_handler "$url"`

prefix=`echo $parsed_url | cut -d'&' -f 1`

process_parsed_url parsed_url prefix

		
		



	



