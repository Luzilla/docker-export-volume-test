#!/bin/sh

# shell script creates something in /data
# we use this to prime it, so we can check out
# export works, etc.

mkdir -p /data/something
touch /data/something/till.txt
echo "Hello World!" > /data/something/till.txt
