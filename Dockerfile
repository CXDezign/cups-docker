FROM debian:unstable-slim

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TIMEZONE="Europe/Warsaw"
ENV USERNAME=username
ENV PASSWORD=password

# Labels
LABEL org.opencontainers.image.source="https://github.com/CXDezign/cups-docker" \
	org.opencontainers.image.description="Dockerized Print (CUPS) Server" \
	org.opencontainers.image.author="CXDezign <contact@cxdezign.com>" \
	org.opencontainers.image.url="https://github.com/CXDezign/cups-docker/blob/main/README.md" \
	org.opencontainers.image.licenses=MIT

# Dependencies
RUN apt update -qqy && \
	apt upgrade -qqy && \
	apt install --no-install-recommends -y \
				avahi-utils \
                cups \
                cups-client \
                cups-bsd \
                cups-filters \
                cups-browsed \
                printer-driver-all \
                printer-driver-cups-pdf \
                printer-driver-gutenprint \
                foomatic-db-engine \
                foomatic-db-compressed-ppds \
                openprinting-ppds \
				libcupsimage2 \
				libxml2 && \
	rm -rf /var/lib/apt/lists/*

# PPDs
COPY ./ppd/cnijfilter2_6.80-1_arm64.deb /tmp/cnijfilter2.deb
RUN apt install -y /tmp/cnijfilter2.deb && \
	rm -f /tmp/cnijfilter2.deb

# Backup Default Configuration
RUN cp -rp /etc/cups /etc/cups.bak

# Volume
VOLUME [ "/etc/cups" ]

# Ports
EXPOSE 631

# Entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
