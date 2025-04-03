#!/bin/sh

set -e

if [ -e result ] && ! rmdir result; then
    if [ $# -gt 0 -a "$1" = "-f" ]; then
        rm -r result
    else
        echo "Please remove the result folder, or call with -f to do it automatically."
        exit 1
    fi
fi

pushd ../../
glistix build
popd
nix eval --write-to result --file test.nix

echo "Written to folder ./result"
