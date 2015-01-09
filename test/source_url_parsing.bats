#!/usr/bin/env bats

load test_helper

@test "git url from gist id" {
	. $LIBDIR/github.sh
	git_url=$(gist_id_to_git 1234)
	[[ $git_url == "https://gist.github.com/1234.git" ]]
}