# Some basic, very useful file utilities

o_mkdir() {
	ohai "Created directory $@"
	mkdir "$@"
}

o_touch() {
	ohai "Touched file $@"
	touch "$@"
}

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