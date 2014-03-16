# Thanks Homebrew for the "creative" names :)

#_____________
#[ Messaging ]

ohai() {
	echo "`_fg_green``_style_bold`==> `_sgrnaught`$1"
}

opoo() {
	echo "`_fg_yellow``_style_bold`==> `_sgrnaught`$1"
}

onoe() {
	echo "`_fg_red``_style_bold`==> `_sgrnaught`$1"
}

# Prints stuff about filing an issue at Github
gh_issue_info() {
	echo >&2 "$(tput setaf 1)An issue can be filed at"
	echo >&2 "https://github.com/ArchimedesPi/mordor/issues"
	echo >&2 "Please check existing issues, and include the following data in your issue:$(tput sgr 0)"
}

# Thanks Gil Gonçalves!

# The MIT License (MIT)
#
# Copyright (c) 2014 Gil Gonçalves
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

_hr() {
	COLS="$(tput cols)"
	if (( COLS <= 0 )) ; then
    	COLS="${COLUMNS:-80}"
	fi

    local WORD="$1"
    if [[ -n "$WORD" ]] ; then
        local LINE=''
        while (( ${#LINE} < COLS ))
        do
            LINE="$LINE$WORD"
        done

        echo "${LINE:0:$COLS}"
    fi
}