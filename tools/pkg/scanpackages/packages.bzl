def _packages_file_impl(ctx):
    out = ctx.outputs.out
    if out == None:
        out = ctx.actions.declare_file(ctx.label.name)
    srcs = ctx.files.srcs

    args = ctx.actions.args()
    args.add(out)
    args.add(ctx.attr.relative_to)
    args.add_all(srcs, before_each = "--package")

    ctx.actions.run(
        outputs = [out],
        inputs = srcs,
        executable = ctx.executable._generate_packages_file,
        arguments = [args],
    )

    return [DefaultInfo(files = depset([out]))]

packages_file = rule(
    implementation = _packages_file_impl,
    attrs = {
        "out": attr.output(),
        "relative_to": attr.string(),
        "srcs": attr.label_list(allow_files = True, mandatory = True),
        "_generate_packages_file": attr.label(
            executable = True,
            default = Label("//tools/pkg/scanpackages"),
            cfg = "exec",
        ),
    },
)
