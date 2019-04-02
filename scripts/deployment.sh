#!/usr/bin/env bash

UPSTREAMS="
upstream backend_blue-green {
        server localhost:81;
        server localhost:82;
}

upstream backend_green {
     server localhost:81;
}

upstream backend_blue {
        server localhost:82;
}

server {
        listen 80;
        location / {
            proxy_pass http://backend_$1;
        }
}
"

if [ "$1" == "green" ]
then
cat <<EOF > /etc/nginx/conf.d/load-balancer.conf
$UPSTREAMS
EOF
sudo nginx -s reload
exit 0

elif [ "$1" == "blue" ]
then
cat <<EOF > /etc/nginx/conf.d/load-balancer.conf
$UPSTREAMS
EOF
sudo nginx -s reload
exit 0

elif [ "$1" == "blue-green" ]
then
cat <<EOF > /etc/nginx/conf.d/load-balancer.conf
$UPSTREAMS
EOF
sudo nginx -s reload
exit 0

else
echo "Wrong deployment method - only 'blue', 'green' or 'blue-green' allowed !!!"
exit 1

fi                                                                                                                  
