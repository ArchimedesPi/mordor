# Text manipulation tools

# Everything-After cutter
# cut_after 'abc:def' ':' 'lol-im-an-error'
cut_after() {
	# Our string
	local str="$1"
	# Our delimiter
	local del="$2"
	# Which end?
	# front *or* end
	local pos="$3"

	# Split *all* the things!
	case $str in
  		(*"$sep"*)
    			local front=${str%%"$del"*}
    			local end=${str#*"$del"}
    			;;
  		(*)
    			local front=$str
    			local end=
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
			gh_issue_info
			onoe "Incorrect positional call to cut_after()"
			onoe "Call was:"
			onoe "		cut_after $str $del $pos"
			onoe "__________________________|"
			echo
			_hr '!'
			#exit 1
			;;
	esac
}