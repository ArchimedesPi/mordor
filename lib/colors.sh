_reset_formatting=`tput sgr0`
_black=0
_red=1
_green=2
_yellow=3
_blue=4
_magenta=5
_cyan=6
_white=7

function _color() {
	echo `tput setaf $1`
}

function _bg_color() {
	echo `tput setab $1`
}