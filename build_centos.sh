#!/bin/sh

#linux_installation_guide
#Please run as root user!

while true; do
    read -p "Do you wish to continue building the program?[y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please enter yes or no.";;
    esac
done

#init the folder
currentpath=$(pwd)
miniupnpc_tar=$currentpath/miniupnpc-1.7.20120830.tar.gz
boost_tar=$currentpath/boost_1_59_0.tar.gz
leveldb_tar=$currentpath/v1.20.tar.gz

miniupnpc_path=$currentpath/miniupnpc-1.7.20120830/
leveldbpath=$currentpath/leveldb-1.20/
fc=$currentpath/fast-compile
blockchain=$currentpath/SelfSell-linux/Chain

#check file or folder exists

if [ -f "$boost_tar" ]; then
echo "$boost_tar exist"
else
echo "ERROR--$boost_tar not exist"
exit
fi

if [ -f "$leveldb_tar" ]; then
echo "$leveldb_tar exist"
else
echo "ERROR--$leveldb_tar not exist"
exit
fi

if [ -f "$miniupnpc_tar" ]; then
echo "$miniupnpc_tar exist"
else
echo "ERROR--$miniupnpc_tar not exist"
exit
fi

if [ -d "$fc" ]; then
echo "$fc exist"
else
echo "ERROR--$fc not exist"
exit
fi

if [ -d "$blockchain" ]; then
echo "$blockchain exist"
else
echo "ERROR--$blockchain not exist"
exit
fi

echo "Enter Y if you want to continue building the program when installing some dependent packages !!!"

echo "[1/5] 1. start install boost，it will take 5-10 minutes..."

export LC_ALL="en_US.UTF-8"
tar -zxvf boost_1_59_0.tar.gz
cd boost_1_59_0
./bootstrap.sh  
./b2

mkdir /usr/local/boost_1_59_0
mkdir /usr/local/boost_1_59_0/include
mkdir /usr/local/boost_1_59_0/lib64
cp -rf boost /usr/local/boost_1_59_0/include
cp -rf stage/lib/* /usr/local/boost_1_59_0/lib64
cd $currentpath/


echo "[2/5] 2. start build and  install the leveldb [1.18 or later]..."

if [ -f $leveldb_tar ]; then 
    echo "unzip leveldb source files"
    tar -zxvf v1.20.tar.gz
 else
    echo
fi

if [ -d "$leveldb_path" ]; then
    cd $leveldb_path
    make
    sudo scp out-static/lib*  /usr/local/lib/
    cd ..
else
    echo "Error: there are no related leveldb files, pls check ..."
fi

echo "[3/5] 3. start  build and install the miniupnpc [ only  1.7 ]..."

if [ -f $miniupnpc_tar ]; then 
    echo "unzip miniupnpc..."
    tar -zxvf miniupnpc-1.7.20120830.tar.gz
else
    echo
fi
if [ -d "$miniupnpc_path" ]; then
    cd $miniupnpc_path
    cmake .
    make
    sudo make install
    cd ..
else
    echo "Error: there are no related miniupnpc files, pls check ..."
fi 

echo "[4/5] 4. start build fast-compile library，it will task a moment..."

if [ -d "$fc" ]; then
    cd $fc
    cmake .
    make
    cp libfc.a  /usr/local/lib/
    cp $fc/vendor/secp256k1-zkp/src/project_secp256k1-build/.libs/libsecp256k1.a /usr/local/lib
    cd ..
else
    echo "Error: no related fast-compile files, pls check..."
fi

echo
echo "[5/5] 5. start build SelfSell,it will take 5-10 minutes ..."
echo

if [ -d "$blockchain" ]; then
    cd $blockchain
    cmake .
    make
    cd ..
else
    echo "Error: no related SelfSell_linux files, pls check..."
fi

echo "Info: finished work successfully, please move $blockchain/SelfSell to the running directory "
