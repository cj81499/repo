load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")
load("//tools/pkg:ar.bzl", "pkg_ar")

def pkg_deb(name, out, control, data):
    # A deb is an ar archive file that contains 3 files:
    # - debian-binary, a text file containing "2.0\n"
    # - control.tar(.gz|.xz|.zst), a(n) (optionally compressed) tar archive containing scripts and package metadata
    # - data.tar(.gz|.xz|.zst|.bz2|.lzma), a(n) optionally compressed) tar archive containing the installable files
    #
    # https://en.m.wikipedia.org/wiki/Deb_(file_format)#Implementation
    # https://manpages.debian.org/unstable/dpkg-dev/deb.5.en.html
    # https://tldp.org/HOWTO/Debian-Binary-Package-Building-HOWTO/x60.html

    write_file(
        name = "control_file",
        out = "control",
        content = control,
    )

    pkg_tar(
        name = "control_tar",
        srcs = [":control_file"],
        out = "control.tar.xz",
        extension = "tar.xz",
    )

    pkg_ar(
        name = name,
        srcs = ["//tools/pkg:debian_binary", ":control_tar", data],
        out = out,
    )
