#!/bin/bash

installNodeAndYarn () {
    echo "Installing nodejs and yarn..."
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt-get install -y nodejs npm
    sudo apt-get update -y
    sudo npm install -g yarn
    sudo npm install -g pm2
    clear
}

installNginx () {
    echo "Installing nginx..."
    sudo apt-get install -y nginx
    sudo rm -f /etc/nginx/sites-available/default
    sudo cat > /etc/nginx/sites-available/default << EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html index.htm index.nginx-debian.html;
    #server_name explorer;
    server_name phore-explorer;

    gzip on;
    gzip_static on;
    gzip_disable "msie6";

    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_buffers 16 8k;
    gzip_http_version 1.1;
    gzip_min_length 256;
    gzip_types text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;

    location / {
        proxy_pass http://127.0.0.1:3000;
            proxy_http_version 1.1;
            proxy_set_header Upgrade \$http_upgrade;
            proxy_set_header Connection 'upgrade';
            proxy_set_header Host \$host;
            proxy_cache_bypass \$http_upgrade;
    }

    #listen [::]:443 ssl ipv6only=on; # managed by Certbot
    #listen 443 ssl; # managed by Certbot
  }

  #server {
    #	listen 80 default_server;
    #	listen [::]:80 default_server;
    #
    #}
EOL
    sudo systemctl start nginx
    sudo systemctl enable nginx
    clear
}

installMongo () {
    echo "Installing mongodb..."
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
    sudo echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
    sudo apt-get update -y
    sudo apt-get install -y --allow-unauthenticated mongodb-org
    sudo chown -R mongodb:mongodb /data/db
    sudo systemctl start mongod
    sudo systemctl enable mongod
    mongo blockex --eval "db.createUser( { user: \"$rpcuser\", pwd: \"$rpcpassword\", roles: [ \"readWrite\" ] } )"
    clear
}

installPhore () {
    echo "Installing Phore..."
    mkdir -p /tmp/phore
    cd /tmp/phore
    curl -Lo phore.tar.gz $phrlink
    tar -xzf phore.tar.gz
    sudo chmod +x phore-${phrvar}/bin/*
    sudo mv phore-${phrver}/bin/* /usr/local/bin
    cd
    rm -rf /tmp/phore
    mkdir -p /home/explorer/.phore
    cat > /home/explorer/.phore/phore.conf << EOL
rpcport=11772
rpcuser=$rpcuser
rpcpassword=$rpcpassword
daemon=1
txindex=1
EOL
    sudo cat > /etc/systemd/system/phored.service << EOL
[Unit]
Description=phored
After=network.target
[Service]
Type=forking
User=explorer
WorkingDirectory=/home/explorer
ExecStart=/home/explorer/bin/phored -datadir=/home/explorer/.phore
ExecStop=/home/explorer/bin/phore-cli -datadir=/home/explorer/.phore stop
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOL
    sudo systemctl start phored
    sudo systemctl enable phored
    echo "Sleeping for 1 hour while node syncs blockchain..."
    sleep 10s
    clear
}

installBlockEx () {
    echo "Installing BlockExplorer..."
    git clone https://github.com/liray-unendlich/phore-explorer.git /home/explorer/phore-explorer
    cd /home/explorer/phore-explorer
    yarn install
    cat > /home/explorer/blockex/config.js << EOL
const config = {
  'api': {
    'host': 'http://127.0.0.1',
    'port': '3000',
    'prefix': '/api',
    'timeout': '180s'
  },
  'coinMarketCap': {
    'api': 'http://api.coinmarketcap.com/v1/ticker/',
    'ticker': 'phore'
  },
  'db': {
    'host': '127.0.0.1',
    'port': '27017',
    'name': 'blockex',
    'user': '$rpcuser',
    'pass': '$rpcpassword'
  },
  'freegeoip': {
    'api': 'https://extreme-ip-lookup.com/json/'
  },
  'rpc': {
    'host': '127.0.0.1',
    'port': '11772',
    'user': '$rpcuser',
    'pass': '$rpcpassword',
    'timeout': 12000, // 12 seconds
  }
};

module.exports = config;
EOL
    node ./cron/block.js
    node ./cron/coin.js
    node ./cron/masternode.js
    node ./cron/peer.js
    node ./cron/rich.js
    clear
    cat > mycron << EOL
*/1 * * * * cd /home/explorer/phore-explorer && ./script/cron_block.sh >> ./tmp/block.log 2>&1
*/1 * * * * cd /home/explorer/phore-explorer && /usr/bin/node ./cron/masternode.js >> ./tmp/masternode.log 2>&1
*/1 * * * * cd /home/explorer/phore-explorer && /usr/bin/node ./cron/peer.js >> ./tmp/peer.log 2>&1
*/1 * * * * cd /home/explorer/phore-explorer && /usr/bin/node ./cron/rich.js >> ./tmp/rich.log 2>&1
*/5 * * * * cd /home/explorer/phore-explorer && /usr/bin/node ./cron/coin.js >> ./tmp/coin.log 2>&1
EOL
    crontab mycron
    rm -f mycron
    pm2 start ./server/index.js
    sudo pm2 startup ubuntu
}

# Setup
echo "Updating system..."
sudo apt-get update -y
sudo apt-get install -y apt-transport-https build-essential cron curl gcc git g++ make sudo vim wget
clear

# Variables
echo "Setting up variables..."
phrlink=`curl -s https://api.github.com/repos/phoreproject/phore/releases/latest | grep browser_download_url | grep x86_64-linux-gnu | cut -d '"' -f 4`
rpcuser=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
rpcpassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
phrver=`curl -s https://api.github.com/repos/phoreproject/Phore/releases/latest | grep tag_name | cut -c 17-21`
echo "Repo: $phrlink"
echo "PWD: $PWD"
echo "User: $rpcuser"
echo "Pass: $rpcpassword"
sleep 5s
clear

# Check for blockex folder, if found then update, else install.
if [ ! -d "/home/explorer/phore-explorer" ]
then
    installNginx
    installMongo
    installPhore
    installNodeAndYarn
    installBlockEx
    echo "Finished installation!"
else
    cd /home/explorer/phore-explorer
    git pull
    pm2 restart index
    echo "BlockEx updated!"
fi

