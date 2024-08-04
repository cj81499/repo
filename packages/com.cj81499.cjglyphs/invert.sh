#!/bin/sh
# invert all pngs in current directory (and children directories) with imagemagick

# requires ImageMagic to be installed
if [ ! -x "$(command -v convert)" ]; then
    echo 'imagemagick not be found'
    echo 'install with "sudo apt install imagemagick"'
    exit 1
fi

# set MAX_PROCS to one less than the number of processors on the machine
MAX_PROCS=$((`nproc`-1))

# find all png images and invert them
# run up to MAX_PROCS instances of convert
find -iname '*.png' | xargs --max-procs=$MAX_PROCS -I % convert % -negate -channel RGB %
