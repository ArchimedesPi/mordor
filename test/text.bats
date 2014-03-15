#!/usr/bin/env bats

load util/text

@test "cut after delimiter: front" {
	result="$(cut_after 'abc:def' ':' 'front')"
	[ "$result" = 'abc' ]
}

@test "cut after delimiter: end" {
	result="$(cut_after 'abc:def' ':' 'end')"
	[ "$result" = 'def' ]
}

#@test "cut after delimiter: graceful error" {
#	result="$(cut_after 'abc:def' ':' 'lol-im-an-error')"
#	[ "$result" = 'abc' ]
#}