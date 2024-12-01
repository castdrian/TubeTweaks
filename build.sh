#!/bin/zsh

if ! command -v python3 &> /dev/null; then
    echo "python3 is not installed. Please install it first."
    exit 1
fi

venv_dir="venv"
if [ ! -d "$venv_dir" ]; then
    echo "Creating virtual environment..."
    python3 -m venv "$venv_dir"
fi

source "$venv_dir/bin/activate"

if ! command -v cyan &> /dev/null; then
    echo "cyan is not installed. Installing in virtual environment..."
    pip install --force-reinstall https://github.com/asdfzxcvbn/pyzule-rw/archive/main.zip Pillow
fi

if ! ls *.ipa >/dev/null 2>&1; then
    echo -n "Enter the decrypted YouTube IPA URL: "
    read yt_url
    echo "Downloading YouTube IPA..."
    if ! curl -L -o YouTube.ipa "$yt_url"; then
        echo "Failed to download IPA"
        exit 1
    fi
fi

rm -rf tmp packages .theos/obj
mkdir -p tmp
if ! unzip -o *.ipa -d tmp >/dev/null 2>&1; then
    echo "Failed to extract IPA"
    exit 1
fi

if ! yt_version=$(plutil -extract CFBundleVersion raw - < tmp/Payload/YouTube.app/Info.plist); then
    echo "Failed to extract version from IPA"
    exit 1
fi
echo "Building for YouTube version: $yt_version"

echo "Building packages..."
if ! make package FINALPACKAGE=1; then
    echo "Failed to build packages"
    exit 1
fi

echo "Preparing IPA..."
rm -rf tmp/Payload/YouTube.app/_CodeSignature/CodeResources
rm -rf tmp/Payload/YouTube.app/PlugIns/*
(cd tmp && zip -r ../*.ipa Payload/)
rm -rf tmp

echo "Injecting..."
if ! cyan -duwsgq -i *.ipa -o "TubeTweaks_${yt_version}.ipa" -f packages/*.deb Tweaks/YTLite/*.deb Extensions/*.appex; then
    echo "Failed to inject files"
    exit 1
fi

deactivate

echo "Build complete! Output file: TubeTweaks_${yt_version}.ipa" 