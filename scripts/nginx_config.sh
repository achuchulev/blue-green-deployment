#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive
export APTARGS="-qq -o=Dpkg::Use-Pty=0"

# Make sure apt repository db is up to date
sudo apt update

# Install tools
echo "Installing tools...."
sudo apt install -y vim wget curl telnet unzip ${APTARGS}

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

sudo bash -c 'cat<<EOF > /var/www/blue/html/index.html
<html>
  <body style="background-color:powderblue;">
  <head>
    <title>Welcome to Blue!</title>
  </head>
  <body>
    <h1>Success! The Blue deployment is working!</h1>
  </body>
</html>
EOF'

sudo bash -c 'cat<<EOF > /var/www/green/html/index.html
<html>
  <body style="background-color:#00ffcc;">
  <head>
    <title>Welcome to Green!</title>
  </head>
  <body>
    <h1>Success! The Green deployment is working!</h1>
  </body>
</html>
EOF'

# sudo bash -c 'cat<<EOF > /etc/nginx/sites-available/blue
# server {
#         listen 8081;
#         listen [::]:8081;

#         root /var/www/blue/html;

#         index index.html index.htm index.nginx-debian.html;

#         server_name _;

#         location / {
#                 # First attempt to serve request as file, then
#                 # as directory, then fall back to displaying a 404.
#                 try_files $uri $uri/ =404;
#         }
# }
# EOF'

# sudo bash -c 'cat<<EOF > /etc/nginx/sites-available/green
# server {
#         listen 8082;
#         listen [::]:8082;

#         root /var/www/green/html;

#         index index.html index.htm index.nginx-debian.html;

#         server_name _;

#         location / {
#                 # First attempt to serve request as file, then
#                 # as directory, then fall back to displaying a 404.
#                 try_files $uri $uri/ =404;
#         }
# }
# EOF'

sudo cp /vagrant/config/* /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/blue /etc/nginx/sites-enabled/blue
sudo ln -s /etc/nginx/sites-available/green /etc/nginx/sites-enabled/green

sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart

sudo /vagrant/scripts/deployment.sh blue