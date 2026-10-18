#!/bin/bash

set -e

echo "=== Updating System Packages ==="
sudo apt update && sudo apt upgrade -y

echo ""
echo "=== Updating Snap Packages ==="
sudo snap refresh

echo ""
echo "=== Updating Rust Toolchain ==="
rustup update

echo ""
echo "=== Updating Cargo Global Binaries ==="
cargo install-update -a

#echo ""
#echo "=== Updating npm ==="
#npm install -g npm@latest

echo ""
echo "=== Updating Global npm Packages ==="
npm update -g

echo ""
echo "=== Clearing npm Cache ==="
npm cache clean --force

echo ""
echo "=== Updating Claude Code ==="
claude update

echo ""
echo "=== Updating Pi ==="
pi update
pi update --extensions

echo ""
echo "=== All done! ==="
