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

echo "Downloading YTLite..."
LATEST_RELEASE=$(curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/dayanch96/YTLite/releases/latest)
DEB_URL=$(echo "$LATEST_RELEASE" | jq -r '.assets[] | select(.name | endswith("iphoneos-arm64.deb")) | .browser_download_url')

if [ -n "$DEB_URL" ]; then
    cd packages
    curl -s -L -O "$DEB_URL"
    cd - > /dev/null
else
    echo "Failed to fetch YTLite release info"
    exit 1
fi

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
if ! make package; then
    echo "Failed to build packages"
    exit 1
fi

echo "Injecting..."
if ! cyan -duwsgq -k icon.png -i *.ipa -o "TubeTweaks_${yt_version}.ipa" -f packages/*.deb; then
    echo "Failed to inject files"
    exit 1
fi

deactivate

echo "Build complete! Output file: TubeTweaks_${yt_version}.ipa" 