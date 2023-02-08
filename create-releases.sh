#!/usr/bin/env sh

VERSION="1.0.0"

FLAGS="-X main.AppVersion=$VERSION -s -w"

# check if `./create-releases.sh docker` is ran which means we only compile for the architecture of the container
if [ $1 = "docker" ]; then
    go build -ldflags="$FLAGS" -trimpath -o veracode-js-packager
else
    rm -rf releases
    mkdir -p releases

    # build for Windows
    GOOS=windows GOARCH=amd64 go build -ldflags="$FLAGS" -trimpath
    mv veracode-js-packager.exe releases/veracode-js-packager-windows-amd64.exe

    # build for M1 Macs (arm64)
    GOOS=darwin GOARCH=arm64 go build -ldflags="$FLAGS" -trimpath
    mv veracode-js-packager releases/veracode-js-packager-mac-arm64

    # build for Intel Macs (amd64)
    GOOS=darwin GOARCH=amd64 go build -ldflags="$FLAGS" -trimpath
    mv veracode-js-packager releases/veracode-js-packager-mac-amd64

    # build for x64 Linux (amd64)
    GOOS=linux GOARCH=amd64 go build -ldflags="$FLAGS" -trimpath
    mv veracode-js-packager releases/veracode-js-packager-linux-amd64
fi
