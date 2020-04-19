#!/bin/bash

while [ $# -gt 0 ]; do
  case "$1" in
  --clientname)
    CLIENTNAME=$2
    shift 2
    ;;

  --passphrase)
    PASSPHRASE=$2
    shift 2
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
	docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME
else
	# without a passphrase (not recommended)
	docker-compose run --rm openvpn easyrsa build-client-full $CLIENTNAME nopass
fi

docker-compose run --rm openvpn ovpn_getclient $CLIENTNAME > $CLIENTNAME.ovpn

