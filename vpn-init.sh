#/bin/bash

TARGET_IP=$1

if [[ -z $TARGET_IP ]]; then
	TARGET_IP=$(curl -4 ifconfig.co)
fi

echo "Configure OpenVPN with IP address: $TARGET_IP"

docker-compose run --rm openvpn ovpn_genconfig -u udp://$TARGET_IP
docker-compose run --rm openvpn ovpn_initpki

docker-compose run --rm openvpn bash -c "echo '' >> /etc/openvpn/openvpn.conf"
docker-compose run --rm openvpn bash -c "echo 'duplicate-cn' >> /etc/openvpn/openvpn.conf"

