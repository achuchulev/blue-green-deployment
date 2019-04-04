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

# Configure nginx virtual hosts

# Create root html content directory for each virtal host
pushd /var/www/
sudo mkdir -p green/html
sudo mkdir -p blue/html
popd

# virtal host blue
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

# virtal host green
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

# Copy virtal hosts' configurations
sudo cp /vagrant/config/* /etc/nginx/sites-available/

# Activate virtal hosts
sudo ln -s /etc/nginx/sites-available/blue /etc/nginx/sites-enabled/blue
sudo ln -s /etc/nginx/sites-available/green /etc/nginx/sites-enabled/green

# Remove default web server configuration
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart

# Activate blue deployment by default
sudo /vagrant/scripts/deployment.sh blue
