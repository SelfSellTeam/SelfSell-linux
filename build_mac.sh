#!/bin/bash

echo "Warning: make sure you have installed dependent packages in your system"
echo "if not, pls read the buildall.sh and run the comment scripts in the beginning"
echo

while true; do
    read -p "Do you wish to continue building the program?[y/n] " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please enter yes or no.";;
    esac
done

currentpath=$(pwd)
leveldbpath=$currentpath/leveldb-1.20/
miniupnpcpath=$currentpath/miniupnpc-1.7.20120830/
leveldbtar=$currentpath/v1.20.tar.gz
miniupnpctar=$currentpath/miniupnpc-1.7.20120830.tar.gz
fc=$currentpath/fast-compile
blockchain=$currentpath/Chain

echo "build and  install the boost1.59 "
cd $currentpath
tar -zxvf boost_1_59_0.tar.gz
cd boost_1_59_0
./bootstrap.sh
./b2

sudo mkdir -p  /usr/local/boost_1_59_0/include
sudo mkdir -p  /usr/local/boost_1_59_0/lib64
sudo mkdir -p  /usr/local/boost_1_59_0/lib

sudo cp -rf boost /usr/local/boost_1_59_0/include
sudo cp -rf stage/lib/* /usr/local/boost_1_59_0/lib64
sudo cp -rf stage/lib/* /usr/local/boost_1_59_0/lib

cd $currentpath

echo "build and  install the leveldb [1.18 or later]"

if [ -f $leveldbtar ]; then 
    echo "unzip leveldb source files"
    tar -zxvf v1.20.tar.gz
 else
    echo
fi

if [ -d "$leveldbpath" ]; then
    cd $leveldbpath
    make
    sudo scp out-static/lib*  /usr/local/lib/
    cd ..
else
    echo "Error: there are no related leveldb files, pls check ..."
fi

echo "build and install the miniupnpc [ only  1.7 ]"

if [ -f $miniupnpctar ]; then 
    echo "unzip miniupnpc..."
    tar -zxvf miniupnpc-1.7.20120830.tar.gz
else
    echo
fi
if [ -d "$miniupnpcpath" ]; then
    cd $miniupnpcpath
    cmake .
    make
    sudo make install
    cd ..
else
    echo "Error: there are no related miniupnpc files, pls check ..."
fi 

echo "build fast-compile library..."

if [ -d "$fc" ]; then
    cd $fc
    cmake .  -DOPENSSL_ROOT_DIR=/usr/local/ssl  -DBOOST_ROOT_DIR=/usr/local/boost_1_59_0 
    make
    sudo cp libfc.a  /usr/local/lib/
    sudo cp $fc/vendor/secp256k1-zkp/src/project_secp256k1-build/.libs/libsecp256k1.a /usr/local/lib
    cd ..
else
    echo "Error: no related fast-compile files, pls check..."
fi

echo
echo "build SelfSell linux code..."
echo

if [ -d "$blockchain" ]; then
    cd $blockchain
    cmake .
    make
    cd ..
else
    echo "Error: no related SelfSell_linux files, pls check..."
fi

echo "Info: finished building work, pls move $blockchain/SelfSell to the running directory "

