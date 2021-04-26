#!/bin/sh
# easy package creation

# run pkg.sh for each package in packages directory
find ./packages/* -maxdepth 0 -type d | xargs -I % sh -c "echo '\nCreate deb for %' && ./packages/pkg.sh % ./jekyll/debs"

# update Packages file
cd jekyll
echo '\nUpdating Packages file'
dpkg-scanpackages --multiversion ./debs > Packages
cd ..
