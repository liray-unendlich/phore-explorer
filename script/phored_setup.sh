#!/bin/bash
# Download latest node and install.
phrlink=`curl -s https://api.github.com/repos/phoreproject/Phore/releases/latest | grep browser_download_url | grep x86_64-linux-gnu | cut -d '"' -f 4`
phrver=`curl -s https://api.github.com/repos/phoreproject/Phore/releases/latest | grep tag_name | cut -c 17-21`
mkdir -p /tmp/phore
cd /tmp/phore
curl -Lo phore.tar.gz $phrlink
tar -xzf phore.tar.gz
sudo mv phore-${ver}/bin/* /usr/local/bin
cd
rm -rf /tmp/phore
mkdir ~/.phore

# Setup configuration for node.
rpcuser=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
rpcpassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
cat >~/.phore/phore.conf <<EOL
rpcuser=$rpcuser
rpcpassword=$rpcpassword
daemon=1
txindex=1
listen=1
server=1
EOL

# Start node.
phored
