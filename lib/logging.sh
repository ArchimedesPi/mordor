#!/bin/bash

function _success() {
	echo "$(_color $_green)-->$_reset_formatting $1"
}

function _info() {
	echo "$(_color $_white)-->$_reset_formatting $1"
}

function _warning() {
	echo "$(_color $_yellow)-->$_reset_formatting $1"
}

function _error() {
	echo "$(_color $_red)-->$_reset_formatting $1"
}
