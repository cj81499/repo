#!/bin/sh
# compress all pngs in current directory (and children directories) with zopflipng

# requires zopfli/zopflipng to be installed
if [ ! -x "$(command -v zopflipng)" ]; then
    echo 'zopflipng not be found'
    echo 'install with "sudo apt install zopfli"'
    exit 1
fi

# set MAX_PROCS to one less than the number of processors on the machine
MAX_PROCS=$((`nproc`-1))

# find all png images and run zopflipng on them
# run up to MAX_PROCS instances of zopflipng
find -iname '*.png' -not -path './_site/*' | xargs --max-procs=$MAX_PROCS -I % zopflipng % % -y
