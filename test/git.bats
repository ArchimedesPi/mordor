#!/usr/bin/env bats

load util/git

@test "getting a repo name from the url" {
	result="$(git_repo_name https://github.com/ArchimedesPi/mordor.git)"
	[ "$result" = 'mordor' ]
}