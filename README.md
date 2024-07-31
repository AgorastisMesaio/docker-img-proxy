# NetKit Container

![GitHub action workflow status](https://github.com/AgorastisMesaio/docker-img-proxy/actions/workflows/docker-publish.yml/badge.svg)

This repository contains a `Dockerfile` aimed to create a *base image* to provide a minimal Linux environment with Squid instance dockerized.

This Docker container is built to run Squid, a high-performance proxy caching server for web clients, supporting HTTP, HTTPS, FTP, and more. It includes OpenSSL for secure connections and tools for network troubleshooting. This container is designed for ease of use, security, and performance, providing a reliable proxy solution out-of-the-box.

## Features

- **Based on Ubuntu:** Utilizes the latest Ubuntu base image for a secure and up-to-date environment.
- **Included Packages:**
  - **OpenSSL:** For secure SSL/TLS connections.
  - **Squid with OpenSSL support:** The main proxy server application.
  - **Curl:** A command-line tool for transferring data with URLs.
  - **iputils-ping:** For network testing and troubleshooting.
  - **dnsutils:** Tools for DNS query testing and troubleshooting.
- **SSL Directory Initialization:** Prepares and initializes directories for SSL support in Squid.
- **Custom Entrypoint Script:** Ensures Squid starts with the necessary configurations and directories properly set up.
- **`/config/run.sh`** You can create your custom bash script that will be called from the `/entrypoint.sh`

## Sample docker-compose.yml

For easier management and scaling, you can use Docker Compose. Below is a sample docker-compose.yml file:

```yaml
version: '3'
services:
  squid-proxy:
    image: squid-proxy:latest
    container_name: squid-proxy
    ports:
      - "3128:3128"
    volumes:
      - ./squid/conf:/etc/squid
      - ./squid/cache:/var/spool/squid
      - ./squid/logs:/var/log/squid
    restart: unless-stopped
```

This docker-compose.yml file does the following:

- Services: Defines a service named squid-proxy.
- Image: Specifies the Docker image to use (squid-proxy:latest).
- Container Name: Names the container squid-proxy.
- Ports: Maps port 3128 on the host to port 3128 in the container.
- Volumes: Mounts local directories for Squid configuration, cache, and logs.
- Restart Policy: Ensures the container restarts automatically unless it is explicitly stopped.

## For developers

If you copy or fork this project to create your own base image.

### Building the Image

To build the Docker image, run the following command in the directory containing the Dockerfile:

```sh
docker build -t your-image/docker-img-proxy:main .
or
docker build -t docker-img-proxy .
```

### Troubleshoot

This will start a container named squid-proxy and map port 3128 on your host to port 3128 in the container, which is the default Squid port.

```sh
docker run --rm --name ct_proxy --hostname proxy -p 3128:3128 -v ./config:/config your-image/docker-img-proxy:main
```
