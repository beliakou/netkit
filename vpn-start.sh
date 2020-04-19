#!/bin/bash

docker-compose up -d

docker-compose exec openvpn bash -c "iptables -t nat -A PREROUTING -i tun0 -p tcp -m tcp --dport 80 -j DNAT --to-destination 10.5.0.3:8080"

# Create new zone "example.org" with nameservers ns1.example.org, ns2.example.org
curl -X POST -v -i \
       	--data '{"name":"example.org.", "kind": "Native", "masters": [], "nameservers": ["ns1.example.org."]}' \
       	-H 'X-API-Key: 34H5G34J5H43H34' \
	http://10.5.0.4:8081/api/v1/servers/localhost/zones


curl -X PATCH \
	--data '{"rrsets": [ {"name": "proxy.example.org.", "type": "A", "ttl": 0, "changetype": "REPLACE", "records": [ {"content": "49.12.44.220", "disabled": false } ] } ] }' \
       	-H 'X-API-Key: 34H5G34J5H43H34' \
	http://10.5.0.4:8081/api/v1/servers/localhost/zones/example.org.
