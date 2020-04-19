#/bin/bash

docker-compose run --rm openvpn ovpn_genconfig -u udp://$(curl -4 ifconfig.co)
docker-compose run --rm openvpn ovpn_initpki

docker-compose run --rm openvpn bash -c "echo '' >> /etc/openvpn/openvpn.conf"
docker-compose run --rm openvpn bash -c "echo 'duplicate-cn' >> /etc/openvpn/openvpn.conf"

