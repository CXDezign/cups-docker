FROM debian:unstable-slim

# Arguments
ARG TARGETPLATFORM
ARG TARGETARCH

# Environment Variables
ENV DEBIAN_FRONTEND=noninteractive
ENV TIMEZONE="Europe/Warsaw"
ENV USERNAME=username
ENV PASSWORD=password

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
                openprinting-ppds \
				libcupsimage2 \
				libxml2 \
				iproute2 && \
	rm -rf /var/lib/apt/lists/*

# PPDs
COPY ./ppd/cnijfilter2_6.80-1_${TARGETARCH}.deb /tmp/cnijfilter2.deb
RUN apt install -y /tmp/cnijfilter2.deb

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
