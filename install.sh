# Install script for Mordor

INSTALLPREFIX='/opt/mordor'
VARPREFIX='/var/mordor'

# Import libraries
. util/messaging.sh
. util/files.sh

echo '=== Installing Mordor ==='
echo
echo
ohai "Installing to $INSTALLPREFIX"
ohai "Settings @ $VARPREFIX"
ohai "Installation user: $USER"
echo
if [ ! -d $INSTALLPREFIX ]; then
	opoo "$INSTALLPREFIX does not exist"
	ohai "Creating $INSTALLPREFIX"
	sudo mkdir $INSTALLPREFIX
	sudo chown $USER $INSTALLPREFIX
fi

if [ ! -d $VARPREFIX ]; then
	opoo "$VARPREFIX does not exist"
	ohai "Creating $VARPREFIX"
	sudo mkdir $VARPREFIX
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
