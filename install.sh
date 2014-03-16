#!/usr/bin/env bash
# Install script for Mordor
INSTALLPREFIX="$1"
if [ -z "$1" ]; then
	INSTALLPREFIX='/usr/local/mordor'
fi

# Import libraries
. util/colors.bash
. util/messaging.bash
. util/files.bash

echo '=== Installing Mordor ==='
echo
echo
ohai "Installing to $INSTALLPREFIX"
ohai "Installation user: $USER"
echo
if [ ! -d $INSTALLPREFIX ]; then
	opoo "$INSTALLPREFIX does not exist"
	ohai "Creating $INSTALLPREFIX"
	sudo mkdir $INSTALLPREFIX
	sudo chown $USER $INSTALLPREFIX
fi

if [ ! -w $INSTALLPREFIX ]; then
	opoo "$INSTALLPREFIX is not writable by the current user"
fi

ohai "Copying files..."

if [ ! -d "$INSTALLPREFIX/util" ]; then
	o_mkdir "$INSTALLPREFIX/util"
fi

if [ ! -d "$INSTALLPREFIX/cache" ]; then
	o_mkdir "$INSTALLPREFIX/cache"
fi

ohai "Copying bash utility libraries"
cp util/* "$INSTALLPREFIX/util"

if [ ! -d "$INSTALLPREFIX/bin" ]; then
	o_mkdir "$INSTALLPREFIX/bin"
fi

ohai "Copying mordor.sh"
cp bin/mordor.sh "$INSTALLPREFIX/bin/mordor"
chmod +x "$INSTALLPREFIX/bin/mordor"

ohai 'Adding mordor to $PATH'
PATHCMD="export PATH=\$PATH:$INSTALLPREFIX/bin"

if grep -q "$PATHCMD" "$HOME/.profile"; then
	:
else
	echo $PATHCMD >> $HOME/.profile
fi

if grep -q "$PATHCMD" "$HOME/.bashrc"; then
	:
else
	echo $PATHCMD >> $HOME/.bashrc
fi

ohai 'Install done.'
_hr '.'
