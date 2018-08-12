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
    mkdir -p /tmp/service/
    cat > /tmp/nginx.conf << EOL
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
    sudo mv /tmp/nginx.conf /etc/nginx/sites-available/default
    sudo systemctl start nginx
    sudo systemctl enable nginx
    clear
}

installMongo () {
    echo "Installing mongodb..."
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5
    sudo echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list
    sudo apt-get update -qqy
    sudo apt-get install -qqy --allow-unauthenticated mongodb-org
    sudo systemctl start mongod
    sudo systemctl enable mongod
    mongo blockex --eval "db.createUser( { user: \"$rpcuser\", pwd: \"$rpcpassword\", roles: [ \"readWrite\" ] } )"
    echo "Finished mongo installation!"
}

installPhore () {
  if [ ${inphr} -eq 1 ]
  then
    return
  else
    echo "Installing Phore..."
    mkdir -p /tmp/phore
    cd /tmp/phore
    curl -Lo phore.tar.gz $phrlink
    tar -xzf phore.tar.gz
    sudo mv phore-${phrver}/bin/* /usr/local/bin
    cd
    rm -rf /tmp/phore
    mkdir -p ${dir}/.phore
    cat > ${dir}/.phore/phore.conf << EOL
rpcport=11772
rpcuser=$rpcuser
rpcpassword=$rpcpassword
daemon=1
txindex=1
staking=0
listen=1
server=1
addnode=1.43.118.91
addnode=103.217.166.63
addnode=104.14.148.127
addnode=104.156.229.204
addnode=104.238.144.108
addnode=104.238.144.67
addnode=104.238.184.178
addnode=107.191.55.244
addnode=111.107.151.41
addnode=144.202.34.83
addnode=149.28.117.225
addnode=149.28.167.27
addnode=155.94.154.176
addnode=156.67.127.246
addnode=163.172.161.150
addnode=173.199.122.209
addnode=173.88.114.199
addnode=178.22.70.41
addnode=185.233.105.46
addnode=194.228.11.75
addnode=199.247.28.44
addnode=199.247.8.233
addnode=207.148.11.27
addnode=207.246.102.58
addnode=207.246.70.5
addnode=207.246.76.98
addnode=212.47.226.127
addnode=213.152.162.5
addnode=217.235.183.11
addnode=217.99.250.102
addnode=24.126.123.16
addnode=37.221.196.161
addnode=45.32.56.14
addnode=45.63.105.43
addnode=45.76.46.249
addnode=45.77.0.228
addnode=45.77.191.205
addnode=45.77.207.83
addnode=45.77.79.247
addnode=45.79.68.234
addnode=46.232.248.122
addnode=46.232.248.132
addnode=46.232.248.157
addnode=46.232.248.162
addnode=46.232.248.205
addnode=46.232.248.233
addnode=46.232.248.64
addnode=46.232.248.81
addnode=46.232.249.10
addnode=46.232.251.71
addnode=46.38.239.232
addnode=47.145.52.144
addnode=5.51.8.11
addnode=5.83.18.254
addnode=62.77.159.162
addnode=72.65.59.251
addnode=73.14.175.152
addnode=74.208.124.203
addnode=74.57.24.54
addnode=78.162.217.62
addnode=78.162.249.209
addnode=79.131.189.94
addnode=88.71.35.102
addnode=92.233.124.175
addnode=94.16.117.52
addnode=94.60.85.88
EOL
    cat > /tmp/phored.service << EOL
[Unit]
Description=phored
After=network.target
[Service]
Type=forking
User=explorer
WorkingDirectory=/home/explorer
ExecStart=/usr/local/bin/phored -datadir=/home/explorer/.phore
ExecStop=/usr/local/bin/phore-cli -datadir=/home/explorer/.phore stop
Restart=on-abort
[Install]
WantedBy=multi-user.target
EOL
    sudo mv /tmp/phored.service /etc/systemd/system/
    sudo systemctl start phored
    sudo systemctl enable phored
    echo "Sleeping for 1 hour while node syncs blockchain..."
    sleep 1h
    echo "Finished Phore daemon installation!"
  fi
}

installBlockExplorer () {
    echo "Installing BlockExplorer..."
    git clone https://github.com/liray-unendlich/phore-explorer.git /home/explorer/phore-explorer
    cd /home/explorer/phore-explorer
    yarn install
    cat > /home/explorer/phore-explorer/config.js << EOL
const config = {
  'api': {
    'host': 'http://${ipaddr}',
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
sudo apt-get update -qqy
sudo apt-get install -qqy jq apt-transport-https build-essential cron curl gcc git g++ make sudo vim wget
sudo "Complete updating!"

# Variables
echo "Setting up variables..."
ipaddr=$(curl -s inet-ip.info)
if [ -n $(which phored) ]
then
  block=$(phore-cli getblockchaininfo | jq .blocks)
  header=$(phore-cli getblockchaininfo | jq .headers)
  inphr=0
  rpcuser=$(grep "rpcuser" .phore/phore.conf | cut -c 9-100)
  rpcpassword=$(grep "rpcpassword" .phore/phore.conf | cut -c 13-100)
  if [ ${block} = ${header} ]
  then
    echo "Your phored is fully synced."
  else
    echo "You need to wait fully syncing. Wait a moment."
    exit
  fi
else
  echo "You didn't install phore daemon. We will install it."
  phrlink=`curl -s https://api.github.com/repos/phoreproject/phore/releases/latest | grep browser_download_url | grep x86_64-linux-gnu | cut -d '"' -f 4`
  rpcuser=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
  rpcpassword=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 32 ; echo '')
  phrver=`curl -s https://api.github.com/repos/phoreproject/Phore/releases/latest | grep tag_name | cut -c 17-21`
  inphr=1
fi
echo "Repo: $phrlink"
echo "PWD: $PWD"
echo "User: $rpcuser"
echo "Pass: $rpcpassword"
echo "IP address: ${ipaddr}"
sleep 5s

# Check for blockex folder, if found then update, else install.

USERNAME=$(whoami)
if [ ${USERNAME} == "root" ]
then
  dir="/root"
else
  dir="/home/"${USERNAME}
fi
if [ ! -d ${dir}"/phore-explorer" ]
then
  mkdir -p ${dir}/install_log/
  installNginx >> ${dir}/install_log/nginx.log
  installMongo >> ${dir}/install_log/mongo.log
  installPhore >> ${dir}/install_log/phore.log
  installNodeAndYarn >> ${dir}/install_log/node.log
  installBlockExplorer >> ${dir}/install_log/explorer.log
  echo "Finished installation!"
  echo "All log within installation is in ${dir}/install_log/"
else
    cd ${dir}/phore-explorer
    git pull
    pm2 restart index
    echo "BlockExplorer updated!"
fi

