#!/bin/bash

# Mordor is simple/stupid. All it does is 
#	* Install itself
# Then you can
#	* Install software (really git clone a sh script and run it)
#	* Parse dependancies from that script
#	* Install ALL the dependancies!
#	* And the software - don't forget that
# The command line syntax is:
# > mordor <url> [...]
# where
#	+ <url> is a URL to a git repo containing a file `Orcfile`.
#		+ <url> can be:
#		|______ + `gist:<gitid>` Enter a gist ID, the gist should contain an Orcfile
#		|______ + `git:<url>`	URL to a git repo, `git://` or `ssh://` or `https://` should work!
#	+ The rest of the arguments are passed to the Orcfile
#
#
#
#   That's all,
#	ArchimedesPi

# Get a repo from git!
get_repo() {
	# Our url
	url="$1"
	# Where does it go / what is is named?
	name="$2"

	####GIT it####
	git clone "$url" "$name"

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
	
	if [[ $url == gist\:* ]] ; then
		gistid = `echo $url | cut -d':' -f 2`
		giturl = `parse_gist "$gistid"`
		return "$giturl"
	elif [[ $url == git\:* ]] ; then
		giturl = `echo $url | cut -d':' -f 2`
		return "$giturl"
	else
		echo "OOOPS! I don't recognize that!"
	fi
}
	



