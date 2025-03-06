#!/bin/bash
set -e

echo "Waiting for WordPress to become available..."
while ! wp core is-installed --allow-root; do
    sleep 2
done

echo "Activating plugins..."
wp plugin activate --all --allow-root

echo "All plugins activated!"
