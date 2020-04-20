#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
  --clientname)
    CLIENTNAME=$2
    shift 2
    ;;

  --passphrase)
    PASSPHRASE=$1
    shift 1
    ;;

  *)
    break
    ;;
  esac
done

if [[ -z $CLIENTNAME ]]; then
	echo "Clientname is required!"; exit 1
fi

if [[ -n $PASSPHRASE ]]; then
	# with a passphrase (recommended)
	echo "Generating with passphrase"
	docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
else
	# without a passphrase (not recommended)
	echo "Generating without passphrase"
	docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
fi

docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

