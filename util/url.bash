# Utilities for parsing URLs

# Parse a Gist url
# parse_gist <id>
parse_gist() {
	# The gist ID
	local id="$1"

	# Example gist structure: https://gist.github.com/7781902.git
	# For the gist https://gist.github.com/ArchimedesPi/7781902

	# So it's really simple:
	
	local git_url="https://gist.github.com/$id.git"
	echo "$git_url"
}

