#!/bin/bash -ex
#import json

export OS_TOKEN=$(curl -i -H "Content-Type: application/json" -d '{ "auth": {"identity": {"methods": ["password"],"password": {"user": {"name": "admin","domain": { "id": "default" },"password": "sde-5561"}}},"scope": {"project": {"name": "admin","domain": { "id": "default" }}}}}' http://172.29.1.13/identity/v3/auth/tokens | awk '/X-Subject-Token/ {print $2}')
echo $OS_TOKEN
export PUBLIC_create=$(curl -s http://172.29.1.13:9696/v2.0/networks -X POST -H "Content-Type: application/json" -H "Accept: application/json" -H "X-Auth-Token:$OS_TOKEN" -d '{"network": {"name":"PUBLIC","provider:network_type":"flat","provider:physical_network":"public","router:external":"true"}}' | python -m json.tool > p.json)
export public=$(cat p.json | jq -r '.network.id')
export PUBLIC_SUBNET=$(curl -s -X POST http://172.29.1.13:9696/v2.0/subnets \
            -H "Content-Type: application/json" \
            -H "X-Auth-Token: $OS_TOKEN" \
            -d "{
			\"subnet\": {
				\"network_id\": \"$public\",
				\"ip_version\": 4,
				\"name\": \"subnet-public\",
				\"cidr\": \"172.24.4.0/24\",
				\"enable_dhcp\": true,
				\"gateway_ip\": \"172.24.4.1\"
			}
		}" | python -m json.tool > psub.json)
export psubid=$(cat psub.json | jq -r '.subnet.id')	
export OS_TOKEN=${OS_TOKEN//$'\015'}	
#curl -X POST "http://172.29.1.13/compute/v2.1/servers" -H "Content-Type: application/json" -H "X-Auth-Token: $OS_TOKEN" -d "{\"server\":{\"name\":\"vm1\",\"imageRef\":\"aaab4dfd-8d9c-409e-a821-a0137e49e869\", \"flavorRef\":42, \"security_groups\": [{\"name\": \"mysg\"}], \"networks\": [{\"uuid\": \"$blue\"}]}}"
