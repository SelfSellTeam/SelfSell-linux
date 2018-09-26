#!/bin/bash

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

if [ -s /etc/oracle-release ]; then
  OS=Oracle
elif [ -s /etc/SuSE-release ]; then
  OS=SuSE
elif [ -f /etc/centos-release ]; then
  OS=CentOS
elif [ -s /etc/redhat-release ]; then
  OS=RedHat
elif [ -f /etc/os-release ]; then
  OS=Ubuntu
fi

echo $OS

INSTALL_CMD="apt-get"

if [ "$OS" == "Ubuntu" ];then
INSTALL_CMD="apt-get"
fi

if [ "$OS" == "CentOS" ];then 
INSTALL_CMD="yum -y "
fi

if [ "$OS" == "CentOS" ];then 
INSTALL_CMD="TODO"
fi

echo "Enter Y if you want to continue building the program when installing some dependent packages !!!"

echo "[1/7] 1. start install dependent packages ..."

if [ "$OS" == "Ubuntu" ];then
apt-get update
apt-get install cmake git libreadline-dev uuid-dev g++ libncurses5-dev zip libssl-dev openssl pkg-config build-essential python-dev autoconf autotools-dev libicu-dev libbz2-dev libtool curl
elif [ "$OS" == "CentOS" ];then
yum -y install cmake git readline-devel uuid-devel gcc ncurses-devel zip openssl openssl-devel pkgconfig python python-devel autoconf libicu-devel bzip2 curl 
else
echo "unknown OS"
fi


echo "[2/7] 2. start install ntp time and do configurations..."

if [ "$OS" == "Ubuntu" ];then
apt-get install ntp 
apt-get install ntpdate
service ntp stop
ntpdate -s time.nist.gov
service ntp start
elif [ "$OS" == "CentOS" ];then
yum install ntp ntpdate -y
systemctl start ntpd
systemctl enable ntpd.service
fi

echo "[3/7] 3. start download boost..."
curl -Lo boost_1_59_0.tar.gz  http://sourceforge.net/projects/boost/files/boost/1.59.0/boost_1_59_0.tar.gz curl http://man.linuxde.net/test.iso --progress


echo "[4/7] 4. start download leveldb version 1.20..."
curl -Lo v1.20.tar.gz https://github.com/google/leveldb/archive/v1.20.tar.gz --progress

echo "[5/7] 5.download miniupnpc..."
curl -Lo miniupnpc-1.7.20120830.tar.gz  http://miniupnp.free.fr/files/download.php?file=miniupnpc-1.7.20120830.tar.gz --progress

echo "[6/7] 6. start build fast-compile library，it will task a moment..."
git clone https://github.com/SelfSellTeam/fast-compile.git
cd fast-compile/vendor
git clone https://github.com/cryptonomex/secp256k1-zkp.git
git clone https://github.com/zaphoyd/websocketpp.git

curl -Lo openssl-1.0.2k.tar.gz  https://www.openssl.org/source/old/1.0.2/openssl-1.0.2k.tar.gz  --progress

echo "[7/7] 7.start download SelfSell Source Code..."
cd $currentpath
git clone https://github.com/SelfSellTeam/SelfSell-linux.git

echo "Info: finished download work successfully,now you can run build_XXX.sh "
