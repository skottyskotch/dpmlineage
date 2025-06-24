#!/bin/bash

set -e

echo "Update repository in progress (force overwrite)..."

if ! command -v git &> /dev/null; then
    echo "git not found. Impossible to update."
else
    git fetch origin
    git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)
    echo "Update finished."
fi

# fetch last version and overwrite all local updates
git fetch origin
git reset --hard origin/$(git rev-parse --abbrev-ref HEAD)

echo "Update finished."
echo "Start Node.js server"

node www/server.js
