#!/usr/bin/env bash

function absolute_path() {
	local dirty_path="$1"
	pushd "$dirty_path" > /dev/null
	local clean_path=`pwd -P`
	popd > /dev/null

	echo "$clean_path"
}

function setup() {
	export LIBDIR=`absolute_path "$BATS_TEST_DIRNAME/../lib"`
}