#!/bin/sh
# Creates a bundle for releasing

if [ -z "$1" ]; then
    echo "Syntax: $0 BASENAME"
    exit 1
fi

if [ -n "$2" ]; then
    cd "$2"
fi

BASENAME="$1"

cp -f "$BASENAME.pom" "pom.xml"
jar cf "$BASENAME-bundle.jar"                           \
    "$BASENAME.jar" "$BASENAME.jar.asc"                 \
    "$BASENAME-sources.jar" "$BASENAME-sources.jar.asc" \
    "$BASENAME-javadoc.jar" "$BASENAME-javadoc.jar.asc" \
    "pom.xml" "$BASENAME.pom.asc"
