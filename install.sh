#!/bin/bash

set -e

echo "Start installation..."

# --- Check Python 3 ---
if ! command -v python3 &> /dev/null; then
    echo "Python 3 is not installed. Please install it as a pre-requisite."
    exit 1
fi

if [ ! -d "venv" ]; then
    echo "Python virtual environment creation..."
    python3 -m venv venv
fi

echo "Virtual environment activation..."
source venv/bin/activate

echo "Installing python dependancies..."
pip install --upgrade pip
pip install -r requirements.txt

# --- Check git ---
if ! command -v git &> /dev/null; then
    echo "git not found, installing..."
    sudo apt-get update
    sudo apt-get install -y git
    echo "git installed."
else
    echo "git already installed."
fi

# --- Check Node.js & npm ---
if ! command -v node &> /dev/null || ! command -v npm &> /dev/null; then
    echo "Node.js or npm not found, install in progress..."

    sudo apt-get update
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt-get install -y nodejs

    echo "Node.js and npm installed."
else
    echo "Node.js and npm already installed."
fi

# --- Node.js modules installation ---
if [ -f "www/package.json" ]; then
    echo "Installing Node.js dependancies in ./www ..."
    cd www
    npm install
    cd ..
else
    echo "No file www/package.json found in ./www."
fi

echo "Installed successfully"
