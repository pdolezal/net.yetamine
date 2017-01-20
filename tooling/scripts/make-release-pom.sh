#!/bin/sh
# Creates a bundle for releasing

if [ -z "$1" ]; then
    echo "Syntax: $0 BASENAME [DIR]"
    exit 1
fi

if [ -n "$2" ]; then
    cd "$2"
fi

BASENAME="$1"

cp -f "$BASENAME.xml" "$BASENAME.pom"
gpg -abs "$BASENAME.pom"
jar cf "$BASENAME-bundle.jar" "$BASENAME.pom" "$BASENAME.pom.asc"
