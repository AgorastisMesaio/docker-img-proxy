
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
if [ ! -f /etc/squid/certificate.key ] || [ ! -f /etc/squid/certificate.pem ]; then
	echo 'Generating certificates'
	openssl genrsa -out /etc/squid/certificate.key 2048
	openssl req -new -key /etc/squid/certificate.key -out /etc/squid/certificate.csr -subj '/C=US/ST=State/L=City/O=Company/CN=localhost'
	openssl x509 -req -days 7300 -in /etc/squid/certificate.csr -signkey /etc/squid/certificate.key -out /etc/squid/certificate.crt
	cat /etc/squid/certificate.crt /etc/squid/certificate.key > /etc/squid/certificate.pem
fi

# Start custom script run.sh
if [ -f ${CONFIG_ROOT}/run.sh ]; then
    cp ${CONFIG_ROOT}/run.sh /run.sh
    chmod +x /run.sh
    /run.sh
fi

# Run the arguments from CMD in the Dockerfile
# In our case we are starting nginx by default
exec "$@"
