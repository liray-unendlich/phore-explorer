#!/bin/bash

installNodeAndYarn () {
    echo "Installing nodejs and yarn..."
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt-get install -y nodejs
    sudo apt-get update -qqy
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
    sudo apt-get update -y
    sudo apt-get install -y --allow-unauthenticated mongodb-org
    sudo systemctl start mongod
    sudo systemctl enable mongod
    mongo blockex --eval "db.createUser( { user: \"$rpcuser\", pwd: \"$rpcpassword\", roles: [ \"readWrite\" ] } )"
    echo "Finished mongo installation!"
}

installPhore () {
  if [ ${inphr} -eq 0 ]
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
rpcuser=$rpcuser
rpcpassword=$rpcpassword
rpcport=11774
port=11773
staking=0
gen=0
daemon=1
txindex=1
addrindex=1
listen=1
server=1
maxconnections=1000
addnode=100.36.179.174
addnode=101.179.206.53
addnode=104.1.155.74
addnode=104.200.25.105
addnode=104.238.170.196
addnode=104.238.176.189
addnode=108.61.203.65
addnode=113.199.161.49
addnode=128.78.141.182
addnode=144.202.49.240
addnode=145.132.232.23
addnode=149.28.109.79
addnode=150.95.148.67
addnode=153.151.188.168
addnode=153.203.246.167
addnode=159.69.217.93
addnode=163.172.161.150
addnode=170.72.86.154
addnode=173.164.137.114
addnode=173.88.114.199
addnode=176.107.131.8
addnode=179.43.152.50
addnode=185.183.156.36
addnode=185.183.156.90
addnode=185.217.171.39
addnode=185.233.104.135
addnode=185.233.105.3
addnode=185.31.158.57
addnode=185.83.110.42
addnode=185.83.110.43
addnode=188.62.35.199
addnode=199.247.17.200
addnode=207.244.109.179
addnode=207.246.101.19
addnode=209.250.254.248
addnode=212.239.211.33
addnode=213.152.162.99
addnode=213.207.135.47
addnode=217.30.70.117
addnode=217.64.248.234
addnode=35.178.34.79
addnode=35.198.167.8
addnode=37.188.166.180
addnode=37.252.126.36
addnode=40.129.190.250
addnode=45.32.125.203
addnode=45.32.56.14
addnode=45.33.46.116
addnode=45.76.86.77
addnode=45.77.2.76
addnode=45.77.79.247
addnode=46.232.248.150
addnode=46.232.248.166
addnode=46.232.248.71
addnode=46.232.249.79
addnode=46.254.64.201
addnode=47.145.52.144
addnode=47.39.199.131
addnode=5.12.83.172
addnode=5.9.13.72
addnode=50.200.100.132
addnode=51.68.214.49
addnode=60.50.3.223
addnode=62.103.241.218
addnode=66.130.44.118
addnode=66.42.51.140
addnode=69.159.53.121
addnode=70.171.119.107
addnode=73.149.235.161
addnode=73.196.107.81
addnode=76.243.195.173
addnode=79.97.137.137
addnode=80.188.248.1
addnode=80.211.205.55
addnode=80.211.42.25
addnode=80.221.47.119
addnode=80.45.27.129
addnode=81.56.10.88
addnode=82.73.161.175
addnode=84.227.60.107
addnode=86.18.4.57
addnode=86.239.68.139
addnode=87.148.149.168
addnode=88.10.8.143
addnode=90.221.86.166
addnode=90.224.162.145
addnode=92.233.124.175
addnode=94.16.123.125
addnode=95.179.143.66
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
    cd ${dir}
    git clone https://github.com/liray-unendlich/phore-explorer.git
    cd ${dir}/phore-explorer
    sudo yarn install
    cat > ${dir}/phore-explorer/config.js << EOL
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
*/1 * * * * cd ${dir}/phore-explorer && ./script/cron_block.sh >> ./tmp/block.log 2>&1
*/1 * * * * cd ${dir}/phore-explorer && /usr/bin/node ./cron/masternode.js >> ./tmp/masternode.log 2>&1
*/1 * * * * cd ${dir}/phore-explorer && /usr/bin/node ./cron/peer.js >> ./tmp/peer.log 2>&1
*/1 * * * * cd ${dir}/phore-explorer && /usr/bin/node ./cron/rich.js >> ./tmp/rich.log 2>&1
*/5 * * * * cd ${dir}/phore-explorer && /usr/bin/node ./cron/coin.js >> ./tmp/coin.log 2>&1
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
echo "Complete updating!"

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
  dir="/root/"
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
