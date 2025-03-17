#!/bin/bash

set -e

VERSION_FILE="VERSION"
VERSION=$(cat $VERSION_FILE)

IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

case "$1" in
    M)
        MAJOR=$((MAJOR+1))
        MINOR=0
        PATCH=0
        ;;
    m)
        MINOR=$((MINOR+1))
        PATCH=0
        ;;
    p)
        PATCH=$((PATCH+1))
        ;;
    *)
        echo "Usage: ./bump-version.sh [M|m|p]"
        exit 1
        ;;
esac

NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
echo "$NEW_VERSION" > $VERSION_FILE
echo "::set-output name=version::$NEW_VERSION"
