def _pkg_ar_impl(ctx):
    out = ctx.outputs.out
    srcs = ctx.files.srcs

    # FIXME: we assume that `ar` is installed and on PATH.
    # Ideally, we should either write our own ar archive from scratch or provide
    # the `ar` executable somehow.
    ctx.actions.run(
        outputs = [out],
        inputs = srcs,
        executable = "ar",
        arguments = ["r", out.path] + [src.path for src in srcs],
    )

    return [DefaultInfo(files = depset([out]))]

pkg_ar = rule(
    implementation = _pkg_ar_impl,
    attrs = {
        "out": attr.output(mandatory = True),
        "srcs": attr.label_list(allow_files = True, mandatory = True),
    },
)
