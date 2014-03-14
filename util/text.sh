# Text manipulation tools

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
			gh_issue_info
			onoes "Incorrect positional call to cut_after()"
			onoes "Call was:"
			onoes "		cut_after $str $del $pos"
			onoes "__________________________|"
			echo
			_hr '!'
			exit 1
			;;
	esac
}