install:
  if [[ `id -u` -ne 0 ]]; then
    echo "$(tput 0)NEEDS ROOT ACCESS$(tput sgr0)"
    exit
  fi
  
  if [ ! -d /opt/mordor ]; then
    mkdir /opt/mordor
  fi
  
  
