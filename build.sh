#!/bin/bash

# Check if cyan is installed
if ! command -v cyan &> /dev/null; then
    echo "cyan is not installed. Installing..."
    pip3 install --force-reinstall https://github.com/asdfzxcvbn/pyzule-rw/archive/main.zip Pillow
fi

# Ask for YouTube IPA URL
read -p "Enter the decrypted YouTube IPA URL: " yt_url

# Create build directory
build_dir="build"
mkdir -p "$build_dir"
cd "$build_dir"

# Download YouTube IPA
echo "Downloading YouTube IPA..."
curl -L -o YouTube.ipa "$yt_url"

# Extract version from IPA
yt_version=$(unzip -p YouTube.ipa 'Payload/YouTube.app/Info.plist' | plutil -extract CFBundleVersion raw -)
echo "Building for YouTube version: $yt_version"

# Build packages
echo "Building packages..."
cd ..
make package FINALPACKAGE=1

# Inject tweaks using cyan
echo "Injecting tweaks..."
cyan -duwsgq -i "$build_dir/YouTube.ipa" -o "$build_dir/TubeTweaks_${yt_version}.ipa" -f Tweaks/YTLite/*.deb packages/*.deb Extensions/*.appex

echo "Build complete! Output file: $build_dir/TubeTweaks_${yt_version}.ipa" 