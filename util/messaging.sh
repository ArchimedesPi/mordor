# Thanks Homebrew for the "creative" names :)

_fg_black() {
	tput setaf 0 
}

_fg_red() {
	tput setaf 1 
}

_fg_green() {
	tput setaf 2 
}

_fg_yellow() {
	tput setaf 3 
}

_fg_blue() {
	tput setaf 4
}

_fg_magenta() {
	tput setaf 5
}

_fg_cyan() {
	tput setaf 6
}

_fg_white() {
	tput setaf 7
}

_style_bold() {
	tput bold
}
_style_dim() {
	tput dim
}

_sgrnaught() {
	tput sgr0
}

ohai() {
	echo "`_fg_green``_style_bold`==> `_sgrnaught`$1"
}

opoo() {
	echo "`_fg_yellow``_style_bold`==> `_sgrnaught`$1"
}

onoe() {
	echo "`_fg_red``_style_bold`==> `_sgrnaught`$1"
}