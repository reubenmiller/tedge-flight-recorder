#!/bin/sh

# Simulate some device traffic so the recorder has some mqtt traffic to record
while :; do
    tedge mqtt pub 'tedge/events/ram' '{"text": "RAM is running a little low, but no cause for alarm just yet 😋"}' ||:
    sleep 2
    tedge mqtt pub 'tedge/events/healthy' '{"text": "Health check: OK"}' ||:
    tedge mqtt pub 'tedge/measurements' '{"temperature": 25}' ||:
    sleep 0.5
    tedge mqtt pub 'tedge/measurements' '{"temperature": 26}' ||:
    sleep 0.5
    tedge mqtt pub 'tedge/measurements' '{"temperature": 27}' ||:
    sleep 0.5
    tedge mqtt pub 'tedge/measurements' '{"temperature": 28}' ||:
    sleep 0.5
    tedge mqtt pub 'tedge/measurements' '{"temperature": 29}' ||:
    sleep 0.5
    tedge mqtt pub 'tedge/measurements' '{"temperature": 30}' ||:
    sleep 0.5
    tedge mqtt pub 'tedge/measurements' '{"temperature": 31}' ||:
    sleep 0.5
    tedge mqtt pub 'tedge/measurements' '{"temperature": 32}' ||:
    sleep 15
done
