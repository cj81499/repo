#!/bin/sh

# echo $0
# echo `dirname $0`


find ./packages/* -maxdepth 0 -type d | xargs -I % sh -c "echo '\nCreate deb for %' && ./packages/pkg.sh % ./jekyll/debs"

cd jekyll

echo '\nUpdating Packages file'
dpkg-scanpackages --multiversion ./debs > Packages

cd ..
