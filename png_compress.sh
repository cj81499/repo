#!/bin/sh

# Requires zopfli/zopflipng to be installed
if [ ! -x "$(command -v zopflipng)" ]; then
    echo "zopflipng not be found"
    echo 'install with "sudo apt install zopfli"'
    exit 1
fi

# Set MAX_PROCS to one less than the number of processors on the machine
MAX_PROCS=$((`nproc`-1))

# Find all png images and run zopflipng on them
# Run up to MAX_PROCS instances of zopflipng
find . -wholename "./jekyll/**/*.png" | xargs --max-procs=$MAX_PROCS -I% zopflipng % % -y
find . -wholename "./packages/**/*.png" | xargs --max-procs=$MAX_PROCS -I% zopflipng % % -y
