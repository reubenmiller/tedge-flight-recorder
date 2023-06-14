FROM debian:11-slim
ENV CASSETTE=cassette.tape
ENV PLAYBACK=1.0.0

# Install additional dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get -y --no-install-recommends install \
        python3-minimal \
        python3-paho-mqtt

COPY images/tedge/tape-playback.py /usr/app/
CMD ["python3", "/usr/app/tape-playback.py", "${CASSETTE}", "${PLAYBACK}"]
