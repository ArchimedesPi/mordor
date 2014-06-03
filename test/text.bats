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

@test "is integer: integer input" {
	is_int 42
}

@test "is_integer: noninteger input" {
	[ ! $(is_int "the answer to life the universe and everything") ]
}