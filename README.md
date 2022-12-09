# hata

This is a collection of reverse engineered Japanese prefectures flags.

See it live here: https://paolobrasolin.github.io/hata/

## Contributing

How do you add a new flag?

1. add `_flags/<PREFECTURE>/banner.tex`,
2. set `placeholder: false` in `_flags/<PREFECTURE>/index.md`,
3. `make _flags/<PREFECTURE>/banner.svg` (or run the right commands manually, see `Makefile`),
4. commit and push.
