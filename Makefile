install:
	if [ `id -u` -ne 0 ]; then
		echo "$(tput 0)NEEDS ROOT ACCESS$(tput sgr0)"
		exit
	fi
	
	mkdir -v /usr/mordor
	install -v mordor.sh /usr/mordor/mordor
	touch -v /usr/mordor/ipkgs
	ln -s -v /usr/mordor/mordor /usr/bin/mordor
  
uninstall:
	if [ `id -u` -ne 0 ]; then
		echo "$(tput 0)NEEDS ROOT ACCESS$(tput sgr0)"
		exit
	fi
	rm -rfv /usr/mordor
	rm -rfv /usr/bin/mordor
	
test:
	echo "Starting tests!"
	# For temporary testing, let's just return sucess!
	exit 0
