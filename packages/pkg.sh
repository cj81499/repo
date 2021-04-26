#!/bin/sh

# check for args
if [ $# -ne 2 ]; then
    echo "usage: $0 package_path output_dir"
    exit 1
fi

# set args
package_path=$1
output_dir=$2

# ensure $package_path is a directory
if [ ! -d $package_path ]; then
    echo "$package_path is not a directory" 1>&2
    exit 1
fi

# ensure $output_dir is a directory
if [ ! -d $output_dir ]; then
    echo "$output_dir is not a directory" 1>&2
    exit 1
fi

# ensure a control file exists
if [ ! -f $package_path/src/DEBIAN/control ]; then
    echo "No control file found" 1>&2
    exit 1
fi

# get the package name
package=`basename $package_path`

# get the version from the control file
version=`sed '/^Version: /!d; s/Version: //' $package_path/src/DEBIAN/control`
version_underscores=`echo $version | sed 's/\./_/g'`

# if a deb for that version already exists, exit with an error
deb_name="${output_dir}/${package}_${version_underscores}.deb"
if [ -f $deb_name ]; then
    echo "A deb already exists for ${package} v$version." 1>&2
    exit 1
fi

# create the deb
echo "Creating deb"
dpkg-deb --build $package_path/src $deb_name
