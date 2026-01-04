load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@rules_pkg//pkg:tar.bzl", "pkg_tar")

def _pkg_deb_rule_impl(ctx):
    # A deb is an ar archive file that contains 3 files:
    # - debian-binary, a text file containing "2.0\n"
    # - control.tar(.gz|.xz|.zst), a(n) (optionally compressed) tar archive containing scripts and package metadata
    # - data.tar(.gz|.xz|.zst|.bz2|.lzma), a(n) optionally compressed) tar archive containing the installable files
    #
    # https://en.m.wikipedia.org/wiki/Deb_(file_format)#Implementation
    # https://manpages.debian.org/unstable/dpkg-dev/deb.5.en.html
    # https://tldp.org/HOWTO/Debian-Binary-Package-Building-HOWTO/x60.html

    out = ctx.outputs.out
    control_tar = ctx.file.control_tar
    data_tar = ctx.file.data_tar

    args = ctx.actions.args()
    args.add_all([
        out.path,
        control_tar,
        data_tar,
    ])
    ctx.actions.run(
        outputs = [out],
        inputs = [
            control_tar,
            data_tar,
        ],
        executable = ctx.executable._make_deb,
        arguments = [args],
    )

    return [DefaultInfo(files = depset([out]))]

_pkg_deb_rule = rule(
    implementation = _pkg_deb_rule_impl,
    attrs = {
        "control_tar": attr.label(allow_single_file = [".tar", ".tar.gz", ".tar.xz", ".tar.zst)"], mandatory = True),
        "data_tar": attr.label(allow_single_file = [".tar", ".tar.gz", ".tar.xz", ".tar.zst", ".tar.bz2", ".tar.lzma"], mandatory = True),
        "out": attr.output(mandatory = True),
        "_make_deb": attr.label(
            default = Label("//tools/pkg:make_deb"),
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
    },
)

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

    _pkg_deb_rule(
        name = name,
        out = out,
        control_tar = ":control.tar.xz",
        data_tar = data,
    )
