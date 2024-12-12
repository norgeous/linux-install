#!/bin/bash
# [[ $EUID -ne 0 ]] && echo "You must be running as user root." && exit 1

sudo apt install -y git build-essential

cd ~
git clone https://github.com/tj/n.git
cd n
sudo make install
cd ..
rm -rf n

#n lts
#n stable
sudo n latest

sudo npm install -g npm

node -v
npm -v

sudo npm i -g ntl # node task list - command line package.json menu
