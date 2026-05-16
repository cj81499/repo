# Contributing

The project is undergoing a transition from ad-hoc shell scripts (and manual stuff) to use [`bazel`](https://bazel.build/).

To get started, install [`direnv`](https://direnv.net/) and [`bazelisk`](https://github.com/bazelbuild/bazelisk) (which will handle installing the appropriate version of `bazel` for you).

## Build everything

```sh
bazel build //...
```

## Build all packages

```sh
bazel build //packages/...
```

## Build a specific package

```sh
bazel build //packages/<PACKAGE>
```

## (Explicitly) build package for "rootless" jailbreak (the default)

<!-- TODO: maybe --config=rootless instead -->
```sh
bazel build --//packages:jailbreak_type=rootless <TARGET>
```

## Build package for "rootful" jailbreak

<!-- TODO: maybe --config=rootful instead -->
```sh
bazel build --//packages:jailbreak_type=rootful <TARGET>
```

## TODO

- [ ] some way to configure version better than hardcoding (CLI arg?)
- [ ] publish a package
- [ ] github actions/workflows to publish (and update workspace to pull `.debs`?)
- [ ] build website
  - [ ] Stick w/ Jekyll - <https://github.com/bazel-contrib/rules_ruby>
  - [ ] Migrate to 11ty - <https://github.com/aspect-build/rules_ts>/<https://github.com/aspect-build/rules_js>
  - [ ] build `Packages`/`Packages.gz` via bazel
