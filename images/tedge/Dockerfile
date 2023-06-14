FROM ghcr.io/thin-edge/tedge-demo-main-systemd:20230517.2

# Install additional dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
        git \
        jq \
        curl

COPY images/tedge/device-traffic.service /lib/systemd/system/
COPY images/tedge/device_traffic.sh /usr/bin/
RUN systemctl enable device-traffic.service \
    && mkdir -p /etc/tedge-tapedeck \
    && chown -R tedge:tedge /etc/tedge-tapedeck

COPY images/tedge/c8y-configuration-plugin.toml /etc/tedge/c8y/c8y-configuration-plugin.toml

COPY images/tedge/recorder /usr/bin/
