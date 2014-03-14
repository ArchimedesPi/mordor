# Some basic, very useful file utilities

o_mkdir() {
	ohai "Created directory $@"
	mkdir "$@"
}

o_touch() {
	ohai "Touched file $@"
	touch "$@"
}

