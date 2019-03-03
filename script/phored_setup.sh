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
port=11773
rpcport=11774
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

# Start node.
phored
