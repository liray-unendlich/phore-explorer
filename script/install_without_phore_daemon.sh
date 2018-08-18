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

installBlockExplorer () {
    echo "Installing BlockExplorer..."
    cd
    git clone https://github.com/liray-unendlich/phore-explorer.git
    cd phore-explorer
    sudo yarn install
    cat > phore-explorer/config.js << EOL
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
    'user': '$dbuser',
    'pass': '$dbpassword'
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

echo "Use this script for first installation."

sleep 5s

# Variables
echo "Setting up variables..."
ipaddr=$(curl -s inet-ip.info)
echo "Please enter username in db."
read dbuser
echo "Please enter password in db."
read dbpassword
echo "Repo: $phrlink"
echo "PWD: $PWD"
echo "Please enter RPC username in phore."
read rpcuser
echo "Please enter RPC password in phore."
read rpcpassword
echo "Phore-RPC username: $rpcuser"
echo "Phore-RPC password: $rpcpassword"
echo "IP address: ${ipaddr}"
sleep 2s

cd
mkdir -p install_log/
installMongo >> install_log/mongo.log
installPhore >> install_log/phore.log
installNodeAndYarn >> install_log/node.log
installBlockExplorer >> install_log/explorer.log
echo "Finished installation!"
echo "All log within installation is in install_log/"