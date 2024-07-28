# Dockerfile for NetKit
#
# This Dockerfile sets up the latest Ubuntu base image for a secure and
# up-to-date environment to run a Squid based Proxy
#

# From Ubuntu
FROM ubuntu:latest
# Install required packages
RUN apt-get update && \
    apt-get install -y openssl squid-openssl curl iputils-ping dnsutils && \
    apt-get clean
# Create directories for SSL and initialize security_file_certgen
RUN mkdir -p /var/lib/squid && \
    rm -rf /var/lib/squid/ssl_db && \
    /usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 20MB && \
    chown -R proxy:proxy /var/lib/squid

# Copy entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Command that will be executed through our entrypoint
CMD ["/usr/sbin/squid", "-N", "-d1"]
