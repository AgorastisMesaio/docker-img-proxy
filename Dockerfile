# Dockerfile for NetKit
#
# This Dockerfile sets up the latest Ubuntu base image for a secure and
# up-to-date environment to run a Squid based Proxy
#

# From Ubuntu
FROM ubuntu:latest
# Install required packages
RUN apt-get update && \
    apt-get install -y openssl squid-openssl curl iputils-ping dnsutils \
                       squidclient nano net-tools tcpdump && \
    apt-get clean
# Create directories for SSL and initialize security_file_certgen
RUN mkdir -p /var/lib/squid && \
    rm -rf /var/lib/squid/ssl_db && \
    /usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 20MB && \
    chown -R proxy:proxy /var/lib/squid

# Copy healthcheck
ADD healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

# My custom health check
# I'm calling /healthcheck.sh so my container will report 'healthy' instead of running
# --interval=30s: Docker will run the health check every 'interval'
# --timeout=10s: Wait 'timeout' for the health check to succeed.
# --start-period=3s: Wait time before first check. Gives the container some time to start up.
# --retries=3: Retry check 'retries' times before considering the container as unhealthy.
HEALTHCHECK --interval=30s --timeout=10s --start-period=3s --retries=3 \
  CMD /healthcheck.sh || exit $?

# Copy entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Command that will be executed through our entrypoint
CMD ["/usr/sbin/squid", "-N", "-d1"]
