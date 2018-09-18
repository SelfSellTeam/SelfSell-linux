#!/bin/sh

#linux_installation_guide
#Please run as root user!
currentpath=$(pwd)

while true; do
    read -p "Do you wish to continue download the program?[y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please enter yes or no.";;
    esac
done


echo "Enter Y if you want to continue building the program when installing some dependent packages !!!"

echo "[1/7] 1. start install dependent packages ..."

apt-get update
apt-get install cmake git libreadline-dev uuid-dev g++ libncurses5-dev zip libssl-dev openssl pkg-config build-essential python-dev autoconf autotools-dev libicu-dev libbz2-dev libtool 


echo "[2/7] 2. start install ntp time and do configurations..."
apt-get install ntp 
apt-get install ntpdate
service ntp stop
ntpdate -s time.nist.gov
service ntp start

echo "[3/7] 3. start download boost..."
wget http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz


echo "[4/7] 4. start download leveldb version 1.20..."
wget -O v1.20.tar.gz https://github.com/google/leveldb/archive/v1.20.tar.gz

echo "[5/7] 5.download miniupnpc..."
wget -O miniupnpc-1.7.20120830.tar.gz http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.7.20120830.tar.gz

echo "[6/7] 6. start build fast-compile library，it will task a moment..."
git clone https://github.com/SelfSellTeam/fast-compile.git
cd fast-compile/vendor
git clone https://github.com/cryptonomex/secp256k1-zkp.git
git clone https://github.com/zaphoyd/websocketpp.git


echo "[7/7] 7.start download SelfSell Source Code..."
cd $currentpath
git clone https://github.com/SelfSellTeam/SelfSell-linux.git

echo "Info: finished download work successfully,now you can run build_XXX.sh "
