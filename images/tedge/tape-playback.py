
import json
import sys
import logging
import time
import os
from paho.mqtt.client import Client

# Set sensible logging defaults
log = logging.getLogger()
log.setLevel(logging.INFO)
handler = logging.StreamHandler()
handler.setLevel(logging.INFO)
formatter = logging.Formatter("%(asctime)s - %(name)s - %(levelname)s - %(message)s")
handler.setFormatter(formatter)
log.addHandler(handler)

def delay(timestamp: float, last_timestamp: float, factor: float):
    if not last_timestamp:
        return timestamp

    duration = (timestamp - last_timestamp) * factor
    
    if duration > 0.001:
        log.info("Waiting %.3fs", duration)
        time.sleep(duration)

    return timestamp

def main(path: str, playback_speed = 1.0, config_file = "/etc/tedge-tapedeck/sony_hifi.json"):
    if os.path.exists(config_file):
        config = json.load(open(config_file))
        playback_speed = config["playback"]["speed"]
        path = config["cassette"]

    if not os.path.exists(path):
        log.info("No cassette tape loaded. Please insert one")
        return

    client = Client("recorder")
    client.connect("localhost", port=1883)

    client.publish("tedge/events/hifi_play", json.dumps({
      "text": f"Playing cassette...playback_speed={playback_speed}",
    }))
    time.sleep(1.0)

    with open(path) as f:
        prev_ts = 0
        for line in f:
            try:
                message = json.loads(line)
                topic = message["message"]["topic"]
                qos = bool(message["message"]["qos"])
                retain = bool(message["message"]["retain"])
                payload = bytes.fromhex(message["payload_hex"]).decode("utf8")
                prev_ts = delay(message["timestamp"], prev_ts, playback_speed)
                log.info("Publishing message: topic=%s, payload=%s", topic, payload)
                client.publish(topic, payload, qos=qos, retain=retain)
            except KeyboardInterrupt:
                log.info("Stopping...")
                return
            except Exception as ex:
                log.warn("Invalid message. %s", ex, exc_info=True)
    
    log.info("Rewinding cassette...")
    client.publish("tedge/events/hifi_rewind", json.dumps({
      "text": "Rewinding cassette",
    }))

if __name__ == "__main__":
    path = "/etc/tedge-tapedeck/cassette.tape"
    if len(sys.argv) > 1:
        path = sys.argv[1]
    playback_speed = 1.0
    if len(sys.argv) > 1:
        playback_speed = float(sys.argv[2])
    
    while True:
        main(path)
        time.sleep(10)
