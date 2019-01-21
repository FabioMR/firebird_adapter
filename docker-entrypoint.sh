#!/bin/bash
# Interpreter identifier

# Exit on fail
set -e

# Ensure all gems installed. Add binstubs to bin which has been added to PATH in Dockerfile.
bundle check || bundle install --binstubs="$BUNDLE_BIN"

# Finally call command issued to the docker service
exec /bin/bash