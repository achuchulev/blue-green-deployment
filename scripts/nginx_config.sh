#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
export APTARGS="-qq -o=Dpkg::Use-Pty=0"

# Make sure apt repository db is up to date
sudo apt update

# Install tools
echo "Installing tools...."
sudo apt install -y wget curl telnet unzip ${APTARGS}

# Check if nginx is installed
# Install nginx if not installed
echo "Installing nginx...."
which nginx &>/dev/null || {
  sudo apt install -y nginx ${APTARGS}
}

# Configure nginx
echo "Configuring nginx virtual hosts...."

pushd /var/www/
sudo mkdir -p green/html
sudo mkdir -p blue/html
popd

sudo cat<<EOF > /var/www/green/html/index.html
<html>
  <body style="background-color:powderblue;">
  <head>
    <title>Welcome to Blue!</title>
  </head>
  <body>
    <h1>Success! The Blue deployment is working!</h1>
  </body>
</html>
EOF

sudo cat<<EOF > /var/www/green/html/index.html
<html>
  <body style="background-color:#00ffcc;">
  <head>
    <title>Welcome to Green!</title>
  </head>
  <body>
    <h1>Success! The Green deployment is working!</h1>
  </body>
</html>
EOF

sudo cat<<EOF > /etc/nginx/sites-available/blue.conf
server {
        listen 81;
        listen [::]:81;
        server_name localhost;
        root /var/www/blue/html;
        index index.html;
        location / {
                try_files $uri $uri/ =404;
        }
}
EOF

sudo cat<<EOF > /etc/nginx/sites-available/green.conf
server {
        listen 81;
        listen [::]:81;
        server_name localhost;
        root /var/www/green/html;
        index index.html;
        location / {
                try_files $uri $uri/ =404;
        }
}
EOF

sudo ln -s /etc/nginx/sites-available/blue.conf /etc/nginx/sites-enabled/blue.conf
sudo ln -s /etc/nginx/sites-available/green.conf /etc/nginx/sites-enabled/green.conf

sudo nginx -s reload
