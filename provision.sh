#!/bin/bash

set -e
set -x

# Intall a bunch of stuff I want ruby built against
apt-get -y update
apt-get -y install libssl-dev libreadline-dev libyaml-dev build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison libffi-dev

# bootstrap off the p0 to get the fpm gem installed.
apt-get -y install ruby1.9.3

gem install fpm --no-rdoc --no-ri

mkdir -p src && cd src

git clone https://github.com/sstephenson/ruby-build.git
cd ruby-build
./install.sh
cd ..


