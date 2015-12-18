#!/bin/sh
# Completes the project skeleton once ready

if [ -n "$1" ]; then
    cd "$1"
fi

git branch release
git add -A
git commit -m "Prepare project skeleton"
git tag version/0.1.0
git checkout -b development
