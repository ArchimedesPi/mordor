#!/usr/bin/env bats

load util/url

@test "parsing gist url" {
	test_gist='7781902'
	result="$(parse_gist $test_gist)"
	[ "$result" = "https://gist.github.com/$test_gist.git" ]
}