#!/usr/bin/env bash
#
# entrypoint.sh for base-proxy
#
# Uncomment for debug
# set -eux
#
# Executed everytime the service is run
# This file is copied as /entrypoint.sh inside the container image.
#

# Variables
export CONFIG_ROOT=/config
CONFIG_ROOT_MOUNT_CHECK=$(mount | grep ${CONFIG_ROOT})

# SQUID configuration
if [ -f ${CONFIG_ROOT}/squid.conf ]; then
    cp ${CONFIG_ROOT}/squid.conf /etc/squid
fi

# Certificates
if [ ! -f /config/certificate.key ] || [ ! -f /config/certificate.pem ]; then
	echo 'Generating certificates'
	openssl genrsa -out /config/certificate.key 2048
  if [ -f ${CONFIG_ROOT}/openssl.cnf ]; then
  	openssl req -new -key /config/certificate.key -out /config/certificate.csr -config /config/openssl.cnf
  else
  	openssl req -new -key /config/certificate.key -out /config/certificate.csr -subj '/C=US/ST=State/L=City/O=Company/CN=localhost'
  fi
  openssl x509 -req -days 7300 -in /config/certificate.csr -signkey /config/certificate.key -out /config/certificate.crt
	cat /config/certificate.crt /config/certificate.key > /config/certificate.pem
fi

#echo 'Sumwall: Installing certificates'
cp /config/certificate.pem /etc/squid
cp /config/certificate.key /etc/squid

# Start custom script run.sh
if [ -f ${CONFIG_ROOT}/run.sh ]; then
    cp ${CONFIG_ROOT}/run.sh /run.sh
    chmod +x /run.sh
    /run.sh
fi

# Run the arguments from CMD in the Dockerfile
# In our case we are starting nginx by default
exec "$@"
