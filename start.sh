#!/bin/bash

set -e

echo "Update repository in progress (force overwrite)..."

if ! command -v git &> /dev/null; then
    echo "git not found. Impossible to update."
	
else
	# REPO_URL="https://gitlab.com/ton-utilisateur/ton-projet.git"
	REPO_URL="git@gitlab.com:ton-utilisateur/ton-projet.git"

	PROJECT_DIR="."

	if [ ! -d "$PROJECT_DIR/.git" ]; then
		echo "Repository first clone..."
		git clone "$REPO_URL" "$PROJECT_DIR"
	else
		echo "Repository already cloned."
	fi

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