#!/bin/bash

docker-compose up -d

# Forward all HTTP traffic to Nginx
docker-compose exec openvpn bash -c "iptables -t nat -A PREROUTING -i tun0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 10.5.0.3:8080"

# Create new zone "internal"
curl -X POST -i \
       	--data '{"name":"internal.", "kind": "Native", "masters": [], "nameservers": ["ns1.internal."]}' \
       	-H 'X-API-Key: MCv2XyZ2nFxPZxAxdosBxBWcVe32' \
	http://10.5.0.4:8081/api/v1/servers/localhost/zones

