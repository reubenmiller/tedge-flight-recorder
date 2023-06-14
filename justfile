set dotenv-load

# Start the demo
up-device *args="":
    docker compose up -d --build {{args}}

# Stop the demo
down-device *args="":
    docker compose down {{args}}

# Stop the demo and destroy the data
down-all:
    docker compose down -v

# Configure and register the device to the cloud
bootstrap *args="--no-prompt":
    docker compose exec --env "DEVICE_ID=${DEVICE_ID:-}" --env "C8Y_BASEURL=${C8Y_BASEURL:-}" --env "C8Y_USER=${C8Y_USER:-}" --env "C8Y_PASSWORD=${C8Y_PASSWORD:-}" tedge bootstrap.sh {{args}}

# Start a shell
shell *args='bash':
    docker compose exec tedge {{args}}

# Show logs of the main device
logs *args='':
    docker compose exec tedge journalctl -f -u "c8y-*" -u "tedge-*" {{args}}


# Install python virtual environment
venv:
  [ -d .venv ] || python3 -m venv .venv
  ./.venv/bin/pip3 install -r tests/requirements.txt

# Run tests
test *args='':
  ./.venv/bin/python3 -m robot.run --outputdir output {{args}} tests
