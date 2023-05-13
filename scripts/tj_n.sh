#!/bin/bash
[[ $EUID -ne 0 ]] && echo "You must be running as user root." && exit 1

apt install -y git build-essential

cd ~
git clone https://github.com/tj/n.git
cd n
make install
cd ..
rm -rf n

#n lts
#n stable
n latest

npm install -g npm

node -v
npm -v

npm i -g ntl
