#!/usr/bin/env bash

UPSTREAMS="upstream backend_blue-green {
     server localhost:8081;
     server localhost:8082;
}

upstream backend_blue {
     server localhost:8081;
}

upstream backend_green {
        server localhost:8082;
}

server {
   listen 80; 

   location / {
      proxy_pass http://backend_$1;
   }
}
"
if [ "$#" -lt "1" ]; then
  echo "argument missing!"
  exit 1
fi

if [ "$1" == "green" ]; then
cat <<EOF > /etc/nginx/conf.d/load-balancer.conf
$UPSTREAMS
EOF
sudo nginx -s reload
exit 0

elif [ "$1" == "blue" ]; then
cat <<EOF > /etc/nginx/conf.d/load-balancer.conf
$UPSTREAMS
EOF
sudo nginx -s reload
exit 0

elif [ "$1" == "blue-green" ]; then
cat <<EOF > /etc/nginx/conf.d/load-balancer.conf
$UPSTREAMS
EOF
sudo nginx -s reload
exit 0

else
echo "Incorrect argument - only 'blue', 'green' or 'blue-green' allowed!"
exit 1

fi                                                                                                                  
