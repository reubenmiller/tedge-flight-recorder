#!/bin/sh

# Simulate some device traffic so the recorder has some mqtt traffic to record
while :; do
    tedge mqtt pub 'tedge/events/ram' '{"text": "RAM is running a little low, but no cause for alarm just yet 😋"}' ||:
    sleep 10s
done
