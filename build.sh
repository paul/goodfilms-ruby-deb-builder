#!/bin/bash

set -x
set -e

TEMPLATE=$1
INSTALL_DIR=~/build/${TEMPLATE}

RUBY_VERSION=`expr "${TEMPLATE}" : 'ruby-\([0-9]\.[0-9]\.[0-9]\)'`
RUBY_DIST=`expr "${TEMPLATE}" : '.*_\([-_a-zA-Z0-9]\+\)'`
RUBY_NAME="ruby-${RUBY_DIST}"

RUBY_CONFIGURE_OPTS="--disable-install-doc" ruby-build --verbose /vagrant/${TEMPLATE}.template ${INSTALL_DIR}

fpm -s dir -t deb -n ${RUBY_NAME} -v ${RUBY_VERSION} -C ${INSTALL_DIR} \
  -p ${RUBY_NAME}-VERSION_ARCH.deb -d "libstdc++6 (>= 4.4.3)" \
  -d "libc6 (>= 2.6)" -d "libffi6 (>= 3.0.10)" -d "libgdbm3 (>= 1.8.3)" \
  -d "libncurses5 (>= 5.7)" -d "libreadline6 (>= 6.1)" \
  -d "libssl1.0.0 (>= 1.0.0)" -d "zlib1g (>= 1:1.2.2)" \
  --force \
  bin include lib share

cp ${RUBY_NAME}*.deb /vagrant/
