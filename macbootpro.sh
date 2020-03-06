#!/bin/bash

set -e


echo "> Checking Homebrew..."
if ! which -s brew
then
    echo "Please install Homebrew first: https://brew.sh"
    exit 1
fi

echo "> Updating Homebrew..."
brew update

echo "> Install Mac App Store CLI..."
brew install mas
