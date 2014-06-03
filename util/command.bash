# All the command-line parsers

# The raw callback
command-line() {
	# The input
	input="$1"

	# Temporary delimiter table
	d_branch='$'
	d_commit='@'
	d_package=':'

	# see docs/usage.md for why i'm doing this
	if is_int $input; then
		echo "gist:$1"
		return
	fi

	n_branch=`count_symbol "$d_branch" "$input"`
	n_commit=`count_symbol "$d_commit" "$input"`
	n_package=`count_symbol "$d_package" "$input"`

	total_delims=$(($n_branch+$n_commit+$n_package))
	echo $total_delims

	if [ $total_delims -eq 0 ]; then
		echo "sauron:$1"
	fi

	
}