# cj81499's Repo

[![Deploy to GitHub Pages](https://github.com/cj81499/repo/actions/workflows/github_pages.yml/badge.svg)](https://github.com/cj81499/repo/actions/workflows/github_pages.yml)

Home of [cjGlyphs](https://www.reddit.com/r/iOSthemes/comments/2r45jz/custom_glyphsgotham_icons/), [(Semi)Official Glyphs](https://www.reddit.com/r/iOSthemes/comments/3hnz0d/release_semiofficial_glyphs_for_ios_8/), [(Semi)Official Space BlueBerry](https://www.reddit.com/r/iOSthemes/comments/3m29cs/release_semiofficial_space_blueberry_for_ios_8/), [(Semi)Official Mandolino](https://www.reddit.com/r/iOSthemes/comments/3nx516/release_semiofficial_mandolino_for_ios_8/), and more!

## Configure githooks

```shell
git config core.hooksPath .githooks
```

<!-- FIXME: bazel-ify -->
## Compress Images

```shell
./png_compress.sh
```

## Publish workflow idea

- GitHub actions workflow to build & publish GitHub release
- bazel `http_archive` to "consume" published `.deb`
- bazel build of site that uses the `.deb`s stored on GitHub (NOT in git repo though!!!)
  - ideally, `.deb`s are **not** needed when developing (only when building for website release/publish/deploy to GH pages)
