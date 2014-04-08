#!/bin/bash

set -e
set -x

# Intall a bunch of stuff I want ruby built against
sudo apt-get -y update
sudo apt-get -y install libssl-dev libreadline-dev libyaml-dev build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison libffi-dev

# bootstrap off the p0 to get the gem installed.
if [[ ! $(which ruby) ]]; then
sudo apt-get -y install ruby1.9.3
fi

# for some reason this installs over and over again. skip it if we can.
if [[ ! $(which fpm) ]]; then
sudo gem install fpm
fi

RUBY_VERSION="2.1.1"
SOURCE_FILE_NAME=ruby-github-${RUBY_VERSION}
INSTALL_DIR=/tmp/install
WORKING_DIRECTORY=/tmp/build
PACKAGE_NAME=${SOURCE_FILE_NAME}_amd64.deb
GITHUB_REPO=https://github.com/github/ruby.git

# clean any previous build artifacts
rm -rf ${INSTALL_DIR}
mkdir ${INSTALL_DIR}

# do all our work in source
mkdir -p ${WORKING_DIRECTORY}
cd ${WORKING_DIRECTORY}

# Download & compile ruby
# if [[ ! -f ${SOURCE_FILE_NAME}.tar.gz ]]; then
# wget ftp://ftp.ruby-lang.org/pub/ruby/1.9/${SOURCE_FILE_NAME}.tar.gz
# fi
# tar -zxvf ${SOURCE_FILE_NAME}.tar.gz
# cd ${SOURCE_FILE_NAME}

if [[ -d ruby ]]; then
  cd ruby
  git pull
else
  git clone $GITHUB_REPO
  cd ruby
fi

time (./configure --prefix=/usr/local --with-opt-dir=/usr/local && make && make install DESTDIR=${INSTALL_DIR})
cd ..

# package up the newly compiled ruby
fpm -s dir -t deb -n ruby-github -v ${RUBY_VERSION} -C ${INSTALL_DIR} \
  -p ruby-github-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
  -d "libc6 (>= 2.6)" -d "libffi6 (>= 3.0.10)" -d "libgdbm3 (>= 1.8.3)" \
  -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
  -d "libssl1.0.0 (>= 1.0.0)" -d "zlib1g (>= 1:1.2.2)" \
  usr/local

# copy the deb package back to your vagrant folder
if [[ -d /vagrant ]]; then
cp ${PACKAGE_NAME} /vagrant/
fi

